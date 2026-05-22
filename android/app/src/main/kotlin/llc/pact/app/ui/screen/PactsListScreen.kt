package llc.pact.app.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import llc.pact.app.data.PactRepository
import llc.pact.app.model.Audience
import llc.pact.app.model.Pact
import llc.pact.app.ui.component.PactCard
import llc.pact.app.ui.component.TopTabs

/**
 * Home screen — "My Pacts" list. Matches screenshot #1 of pact.llc:
 *   ┌─────────────────────────────┐
 *   │       My Pacts        [+]   │
 *   │ [All] Partner Friends Family│
 *   │ ○/● Title                   │
 *   │     with Name · Meta        │
 *   └─────────────────────────────┘
 */
@Composable
fun PactsListScreen(
    repository: PactRepository,
    onNewPact: () -> Unit,
    onOpenPact: (Pact) -> Unit,
) {
    val pacts by repository.pacts.collectAsState()
    var selected by remember { mutableStateOf(Audience.All) }

    val visible = remember(pacts, selected) {
        if (selected == Audience.All) pacts
        else pacts.filter { it.counterpart.audience == selected }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .statusBarsPadding(),
    ) {
        TopBar(onPlus = onNewPact)
        Spacer(Modifier.height(6.dp))
        TopTabs(
            selected = selected,
            onSelect = { selected = it },
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
        )
        Spacer(Modifier.height(8.dp))
        if (visible.isEmpty()) {
            EmptyState(modifier = Modifier.fillMaxSize())
        } else {
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 4.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                items(items = visible, key = { it.id }) { pact ->
                    PactCard(pact = pact, onClick = { onOpenPact(pact) })
                }
                item { Spacer(Modifier.height(16.dp)) }
            }
        }
    }
}

@Composable
private fun TopBar(onPlus: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = "My Pacts",
            style = MaterialTheme.typography.titleLarge,
            color = MaterialTheme.colorScheme.onSurface,
            textAlign = TextAlign.Center,
        )
        Row(
            modifier = Modifier
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.End,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            PlusButton(onClick = onPlus)
        }
    }
}

@Composable
private fun PlusButton(onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .size(38.dp)
            .background(MaterialTheme.colorScheme.surface, CircleShape)
            .clickable(onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            imageVector = Icons.Rounded.Add,
            contentDescription = "New Pact",
            tint = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.size(20.dp),
        )
    }
}

@Composable
private fun EmptyState(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier.padding(horizontal = 32.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = "No pacts here yet.\nTap + to make one.",
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
        )
    }
}
