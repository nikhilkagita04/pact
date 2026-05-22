package llc.pact.app.ui.screen

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Favorite
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import llc.pact.app.data.PactRepository
import llc.pact.app.ui.component.AvatarDot
import llc.pact.app.ui.theme.LocalPactExtras

/**
 * Post-completion celebration (screenshot #4).
 *   - Two overlapping avatars with a small heart peeking behind
 *   - "Pact Complete!" display
 *   - "X sent you a ❤️!" subtitle
 *   - Single teal "Got it!" pill at the bottom
 *
 * The heart/avatar stack gets a spring-in animation — this is the app's
 * emotional payoff, so motion is warranted here and only here.
 */
@Composable
fun CompleteScreen(
    repository: PactRepository,
    pactId: String,
    onDismiss: () -> Unit,
) {
    val pact = remember(pactId) { repository.find(pactId) }
    val extras = LocalPactExtras.current

    val scale = remember { Animatable(0.6f) }
    LaunchedEffect(Unit) {
        scale.animateTo(
            targetValue = 1f,
            animationSpec = spring(
                dampingRatio = Spring.DampingRatioLowBouncy,
                stiffness = Spring.StiffnessMediumLow,
            ),
        )
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = 24.dp)
            .navigationBarsPadding(),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Spacer(Modifier.weight(1f))

        // Avatar pair with heart behind
        if (pact != null) {
            Box(
                modifier = Modifier
                    .graphicsLayer {
                        scaleX = scale.value
                        scaleY = scale.value
                    },
                contentAlignment = Alignment.Center,
            ) {
                // Heart, centered, peeking from between the two circles
                Icon(
                    imageVector = Icons.Rounded.Favorite,
                    contentDescription = null,
                    tint = extras.heart,
                    modifier = Modifier
                        .size(28.dp)
                        .offset(y = (-2).dp),
                )
                // Left avatar — "me"
                Box(
                    modifier = Modifier
                        .offset(x = (-28).dp)
                        .size(88.dp)
                        .background(androidx.compose.ui.graphics.Color(0xFFE8C39E), CircleShape),
                    contentAlignment = Alignment.Center,
                ) {
                    Text(
                        text = "Me",
                        style = MaterialTheme.typography.titleMedium,
                        color = androidx.compose.ui.graphics.Color(0xFF1A1F26),
                    )
                }
                // Right avatar — counterpart
                Box(modifier = Modifier.offset(x = 28.dp)) {
                    AvatarDot(person = pact.counterpart, size = 88.dp)
                }
            }
        }

        Spacer(Modifier.height(40.dp))
        Text(
            text = "Pact\nComplete!",
            style = MaterialTheme.typography.displaySmall.copy(lineHeight = androidx.compose.ui.unit.TextUnit.Unspecified),
            color = MaterialTheme.colorScheme.onSurface,
            textAlign = TextAlign.Center,
        )
        Spacer(Modifier.height(16.dp))
        Text(
            text = buildString {
                append(pact?.counterpart?.name ?: "They")
                append(" sent you a ")
                append("\u2764\uFE0F")
                append("!")
            },
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
        )

        Spacer(Modifier.weight(1.4f))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.primary, CircleShape)
                .clickable(onClick = onDismiss)
                .padding(vertical = 18.dp),
            contentAlignment = Alignment.Center,
        ) {
            Text(
                text = "Got it!",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onPrimary,
            )
        }
        Spacer(Modifier.height(20.dp))
    }
}

// Kept import for readability; silence lint if unused in this rev.
@Suppress("unused")
private val _widthKeep = 0.dp.let { Modifier.width(it) }
