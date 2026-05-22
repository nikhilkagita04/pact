package llc.pact.app.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Close
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
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import kotlinx.datetime.Clock
import llc.pact.app.data.PactRepository
import llc.pact.app.model.Pact
import llc.pact.app.model.PactDirection
import llc.pact.app.model.PactState
import llc.pact.app.model.Person
import llc.pact.app.ui.component.AvatarDot
import kotlin.time.Duration.Companion.days

/**
 * Creating a new pact. Minimal v1 shape:
 *   - Title (auto-focused)
 *   - Who (chip row of known people)
 *   - Direction (3 chips: "I'll do it", "You do it", "Together")
 *   - Description (optional)
 *   - Send button
 *
 * Navigated to via the "+" top button on the list or the "New Pact" bottom tab.
 */
@Composable
fun NewPactScreen(
    repository: PactRepository,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
) {
    val people by repository.people.collectAsState()
    var title by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var who: Person? by remember { mutableStateOf(people.firstOrNull()) }
    var direction by remember { mutableStateOf(PactDirection.IDoForYou) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .statusBarsPadding()
            .padding(horizontal = 20.dp),
    ) {
        // Header — close on the left, title centered
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 12.dp, bottom = 8.dp),
            contentAlignment = Alignment.Center,
        ) {
            Text(
                text = "New Pact",
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.onSurface,
            )
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Start,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Box(
                    modifier = Modifier
                        .size(38.dp)
                        .background(MaterialTheme.colorScheme.surface, CircleShape)
                        .clickable(onClick = onDismiss),
                    contentAlignment = Alignment.Center,
                ) {
                    Icon(
                        imageVector = Icons.Rounded.Close,
                        contentDescription = "Close",
                        tint = MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier.size(18.dp),
                    )
                }
            }
        }

        Spacer(Modifier.height(20.dp))
        SectionLabel("What's the pact?")
        TitleField(
            value = title,
            onChange = { title = it },
            placeholder = "e.g. Pick up Emily's favorite soup",
        )

        Spacer(Modifier.height(24.dp))
        SectionLabel("With who?")
        PeopleRow(
            people = people,
            selected = who,
            onSelect = { who = it },
        )

        Spacer(Modifier.height(24.dp))
        SectionLabel("Who's doing it?")
        DirectionChips(selected = direction, onSelect = { direction = it })

        Spacer(Modifier.height(24.dp))
        SectionLabel("A note (optional)")
        DescriptionField(
            value = description,
            onChange = { description = it },
            placeholder = "Say a little more...",
        )

        Spacer(Modifier.weight(1f))
        SendButton(
            enabled = title.isNotBlank() && who != null,
            onClick = onClick@{
                val person = who ?: return@onClick
                repository.add(
                    Pact(
                        id = "pact-${Clock.System.now().toEpochMilliseconds()}",
                        title = title.trim(),
                        description = description.trim().ifBlank { null },
                        counterpart = person,
                        direction = direction,
                        state = PactState.Active,
                        createdAt = Clock.System.now(),
                        dueAt = Clock.System.now() + 3.days,
                    ),
                )
                onCreated()
            },
        )
        Spacer(Modifier.height(20.dp))
    }
}

@Composable
private fun SectionLabel(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.labelLarge,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(bottom = 10.dp),
    )
}

@Composable
private fun TitleField(value: String, onChange: (String) -> Unit, placeholder: String) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(16.dp))
            .padding(horizontal = 16.dp, vertical = 14.dp),
    ) {
        if (value.isEmpty()) {
            Text(
                text = placeholder,
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        BasicTextField(
            value = value,
            onValueChange = onChange,
            textStyle = MaterialTheme.typography.titleMedium.copy(
                color = MaterialTheme.colorScheme.onSurface,
            ),
            cursorBrush = SolidColor(MaterialTheme.colorScheme.primary),
            modifier = Modifier.fillMaxWidth(),
        )
    }
}

@Composable
private fun DescriptionField(value: String, onChange: (String) -> Unit, placeholder: String) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(16.dp))
            .padding(horizontal = 16.dp, vertical = 14.dp),
    ) {
        if (value.isEmpty()) {
            Text(
                text = placeholder,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        BasicTextField(
            value = value,
            onValueChange = onChange,
            textStyle = MaterialTheme.typography.bodyLarge.copy(
                color = MaterialTheme.colorScheme.onSurface,
            ),
            cursorBrush = SolidColor(MaterialTheme.colorScheme.primary),
            minLines = 2,
            modifier = Modifier.fillMaxWidth(),
        )
    }
}

@Composable
private fun PeopleRow(people: List<Person>, selected: Person?, onSelect: (Person) -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .horizontalScroll(rememberScrollState()),
        horizontalArrangement = Arrangement.spacedBy(10.dp),
    ) {
        people.forEach { p ->
            val isSelected = selected?.id == p.id
            Row(
                modifier = Modifier
                    .background(
                        color = if (isSelected) MaterialTheme.colorScheme.surface
                                else MaterialTheme.colorScheme.background,
                        shape = RoundedCornerShape(50),
                    )
                    .border(
                        width = 1.dp,
                        color = if (isSelected) MaterialTheme.colorScheme.primary
                                else MaterialTheme.colorScheme.outline,
                        shape = RoundedCornerShape(50),
                    )
                    .clickable { onSelect(p) }
                    .padding(horizontal = 10.dp, vertical = 6.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                AvatarDot(person = p, size = 22.dp)
                Spacer(Modifier.size(8.dp))
                Text(
                    text = p.name,
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurface,
                )
            }
        }
    }
}

@Composable
private fun DirectionChips(selected: PactDirection, onSelect: (PactDirection) -> Unit) {
    val options = listOf(
        PactDirection.IDoForYou to "I'll do it",
        PactDirection.YouDoForMe to "You do it",
        PactDirection.Together to "Together",
    )
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        options.forEach { (dir, label) ->
            val isSelected = selected == dir
            Box(
                modifier = Modifier
                    .weight(1f)
                    .background(
                        color = if (isSelected) MaterialTheme.colorScheme.primary
                                else MaterialTheme.colorScheme.surface,
                        shape = RoundedCornerShape(12.dp),
                    )
                    .clickable { onSelect(dir) }
                    .padding(vertical = 12.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    text = label,
                    style = MaterialTheme.typography.labelLarge,
                    color = if (isSelected) MaterialTheme.colorScheme.onPrimary
                            else MaterialTheme.colorScheme.onSurface,
                )
            }
        }
    }
}

@Composable
private fun SendButton(enabled: Boolean, onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = if (enabled) MaterialTheme.colorScheme.primary
                        else MaterialTheme.colorScheme.surface,
                shape = RoundedCornerShape(50),
            )
            .clickable(enabled = enabled, onClick = onClick)
            .padding(vertical = 16.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = "Send Pact",
            style = MaterialTheme.typography.titleMedium,
            color = if (enabled) MaterialTheme.colorScheme.onPrimary
                    else MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}
