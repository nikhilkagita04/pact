// Top-level build file — plugin versions are declared here via apply false so
// subprojects can opt in without repeating version numbers.
plugins {
    alias(libs.plugins.androidApplication) apply false
    alias(libs.plugins.kotlinAndroid) apply false
    alias(libs.plugins.composeCompiler) apply false
    alias(libs.plugins.kotlinxSerialization) apply false
}
