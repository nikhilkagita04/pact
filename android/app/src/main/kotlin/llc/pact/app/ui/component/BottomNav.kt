package llc.pact.app.ui.component

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AddCircle
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.PlaylistAddCheck
import androidx.compose.material.icons.rounded.AddCircle
import androidx.compose.material.icons.rounded.Person
import androidx.compose.material.icons.rounded.PlaylistAddCheck
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp

enum class BottomTab(
    val label: String,
    val iconOutline: ImageVector,
    val iconFilled: ImageVector,
) {
    MyPacts("My Pacts", Icons.Outlined.PlaylistAddCheck, Icons.Rounded.PlaylistAddCheck),
    NewPact("New Pact", Icons.Outlined.AddCircle, Icons.Rounded.AddCircle),
    Profile("Profile", Icons.Outlined.Person, Icons.Rounded.Person),
}

/**
 * Custom bottom nav — Material3's NavigationBar forces an indicator pill we
 * don't want here. The pact.llc aesthetic is flatter: icon + small label,
 * teal tint when selected, grey otherwise. Thin top rule separates it from the
 * scroll area.
 */
@Composable
fun PactBottomNav(
    selected: BottomTab,
    onSelect: (BottomTab) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier = modifier.fillMaxWidth()) {
        HorizontalDivider(
            color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.35f),
            thickness = 1.dp,
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 10.dp),
            horizontalArrangement = Arrangement.SpaceEvenly,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            BottomTab.entries.forEach { tab ->
                NavItem(tab = tab, selected = tab == selected, onClick = { onSelect(tab) })
            }
        }
    }
}

@Composable
private fun NavItem(
    tab: BottomTab,
    selected: Boolean,
    onClick: () -> Unit,
) {
    val tint = if (selected) MaterialTheme.colorScheme.primary
               else MaterialTheme.colorScheme.onSurfaceVariant
    Column(
        modifier = Modifier
            .clickable(onClick = onClick)
            .padding(horizontal = 18.dp, vertical = 6.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Icon(
            imageVector = if (selected) tab.iconFilled else tab.iconOutline,
            contentDescription = tab.label,
            tint = tint,
            modifier = Modifier.size(24.dp),
        )
        Spacer(Modifier.height(4.dp))
        Text(
            text = tab.label,
            style = MaterialTheme.typography.labelMedium,
            color = tint,
        )
    }
}
