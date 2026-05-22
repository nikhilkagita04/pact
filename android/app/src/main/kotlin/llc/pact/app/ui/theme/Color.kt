package llc.pact.app.ui.theme

import androidx.compose.ui.graphics.Color

// Sampled from the pact.llc screenshots to match the premium, minimalist dark aesthetic.
// Keep this file as the single source of truth — reference these tokens through
// MaterialTheme.colorScheme.* in composables, not raw Colors, so a future light
// theme swap is one place.
object PactColors {
    // Background — near-black with a hint of cool. Not pure #000 (which crushes depth).
    val Background = Color(0xFF0A0F14)

    // Cards on the list. Slightly lifted off background.
    val Surface = Color(0xFF1A2028)

    // Elevated surface (incoming request modal, bottom sheets).
    val SurfaceHigh = Color(0xFF252C35)

    // Subtle border on unchecked circles, divider strokes.
    val Outline = Color(0xFF2F3A46)

    // Primary teal — the accent used for checkmark fills, active tab pill, primary CTA.
    val Primary = Color(0xFF4FD1C5)
    val OnPrimary = Color(0xFF0A1F1E)

    // Text hierarchy.
    val OnSurface = Color(0xFFF2F4F7)      // primary text
    val OnSurfaceVariant = Color(0xFFA0A8B3) // secondary text: "with Emily · Due in 2 days"

    // Streak / flame accent — the amber "3 Pacts in a row! 🔥" line.
    val Streak = Color(0xFFF5A524)

    // Heart / love accent — used sparingly (incoming request outline, celebration).
    val Heart = Color(0xFFF05454)

    // Decline button outline — muted, lower weight than Primary.
    val DeclineStroke = Color(0xFF3F4A56)
}
