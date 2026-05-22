package llc.pact.app.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import llc.pact.app.PactApplication
import llc.pact.app.model.PactState
import llc.pact.app.ui.component.BottomTab
import llc.pact.app.ui.component.PactBottomNav
import llc.pact.app.ui.screen.CompleteScreen
import llc.pact.app.ui.screen.IncomingRequestSheet
import llc.pact.app.ui.screen.NewPactScreen
import llc.pact.app.ui.screen.PactDetailScreen
import llc.pact.app.ui.screen.PactsListScreen
import llc.pact.app.ui.screen.ProfileScreen
import llc.pact.app.ui.theme.PactTheme

/**
 * Root composable — owns the NavHost, bottom nav, and the "incoming request"
 * overlay. Repository is pulled from Application (v1) so every screen shares
 * the same in-memory source of truth without wiring a DI container yet.
 */
@Composable
fun PactApp() {
    PactTheme {
        val app = LocalContext.current.applicationContext as PactApplication
        val repository = remember { app.repository }
        val nav = rememberNavController()
        val backStack by nav.currentBackStackEntryAsState()
        val currentRoute = backStack?.destination?.route

        // Which bottom tab to highlight. Detail/complete/new-pact all live
        // inside the "My Pacts" tab conceptually.
        val selectedTab = when (currentRoute) {
            Route.Profile -> BottomTab.Profile
            Route.NewPact -> BottomTab.NewPact
            else -> BottomTab.MyPacts
        }

        // Surface one Pending pact as an incoming-request modal on top of the
        // list. User taps Accept/Decline to resolve. Dismissable by tapping the
        // backdrop — we persist a dismissed set so it doesn't reappear every
        // recomposition.
        val pacts by repository.pacts.collectAsState()
        var dismissedRequestIds by rememberSaveable { mutableStateOf(setOf<String>()) }
        val pendingRequest = pacts.firstOrNull {
            it.state == PactState.Pending && it.id !in dismissedRequestIds
        }

        Scaffold(
            containerColor = MaterialTheme.colorScheme.background,
            bottomBar = {
                PactBottomNav(
                    selected = selectedTab,
                    onSelect = { tab ->
                        val target = when (tab) {
                            BottomTab.MyPacts -> Route.List
                            BottomTab.NewPact -> Route.NewPact
                            BottomTab.Profile -> Route.Profile
                        }
                        if (currentRoute != target) {
                            nav.navigate(target) {
                                popUpTo(Route.List) { saveState = true }
                                launchSingleTop = true
                                restoreState = true
                            }
                        }
                    },
                    modifier = Modifier.navigationBarsPadding(),
                )
            },
        ) { inner ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(MaterialTheme.colorScheme.background)
                    .padding(inner),
            ) {
                NavHost(
                    navController = nav,
                    startDestination = Route.List,
                ) {
                    composable(Route.List) {
                        PactsListScreen(
                            repository = repository,
                            onNewPact = { nav.navigate(Route.NewPact) { launchSingleTop = true } },
                            onOpenPact = { pact ->
                                nav.navigate(Route.detail(pact.id)) { launchSingleTop = true }
                            },
                        )
                    }
                    composable(Route.NewPact) {
                        NewPactScreen(
                            repository = repository,
                            onDismiss = {
                                if (!nav.popBackStack()) {
                                    nav.navigate(Route.List) { launchSingleTop = true }
                                }
                            },
                            onCreated = {
                                nav.navigate(Route.List) {
                                    popUpTo(Route.List) { inclusive = false }
                                    launchSingleTop = true
                                }
                            },
                        )
                    }
                    composable(Route.Profile) {
                        ProfileScreen(repository = repository)
                    }
                    composable(
                        route = Route.DetailPattern,
                        arguments = listOf(navArgument(Route.PactIdArg) { type = NavType.StringType }),
                    ) { entry ->
                        val id = entry.arguments?.getString(Route.PactIdArg) ?: return@composable
                        PactDetailScreen(
                            repository = repository,
                            pactId = id,
                            onBack = {
                                if (!nav.popBackStack()) {
                                    nav.navigate(Route.List) { launchSingleTop = true }
                                }
                            },
                            onCompleted = { completedId ->
                                nav.navigate(Route.complete(completedId)) {
                                    popUpTo(Route.List) { inclusive = false }
                                    launchSingleTop = true
                                }
                            },
                        )
                    }
                    composable(
                        route = Route.CompletePattern,
                        arguments = listOf(navArgument(Route.PactIdArg) { type = NavType.StringType }),
                    ) { entry ->
                        val id = entry.arguments?.getString(Route.PactIdArg) ?: return@composable
                        CompleteScreen(
                            repository = repository,
                            pactId = id,
                            onDismiss = {
                                nav.navigate(Route.List) {
                                    popUpTo(Route.List) { inclusive = false }
                                    launchSingleTop = true
                                }
                            },
                        )
                    }
                }

                // Modal on top of everything. Sized fillMaxSize so backdrop
                // covers the scaffold content (bottom nav stays visible but
                // dimmed — matches the blurred feel of the pact.llc screenshot).
                if (pendingRequest != null) {
                    IncomingRequestSheet(
                        pact = pendingRequest,
                        onAccept = {
                            repository.accept(pendingRequest.id)
                            dismissedRequestIds = dismissedRequestIds + pendingRequest.id
                        },
                        onDecline = {
                            repository.decline(pendingRequest.id)
                            dismissedRequestIds = dismissedRequestIds + pendingRequest.id
                        },
                        onAdjust = {
                            // v1 just dismisses — real adjustment UI is v1.1
                            dismissedRequestIds = dismissedRequestIds + pendingRequest.id
                        },
                        onDismiss = {
                            dismissedRequestIds = dismissedRequestIds + pendingRequest.id
                        },
                    )
                }
            }
        }
    }
}

/** Typed route constants. */
private object Route {
    const val List = "list"
    const val NewPact = "new"
    const val Profile = "profile"
    const val PactIdArg = "pactId"
    const val DetailPattern = "detail/{pactId}"
    const val CompletePattern = "complete/{pactId}"
    fun detail(id: String) = "detail/$id"
    fun complete(id: String) = "complete/$id"
}

