# Keep kotlinx.serialization metadata for @Serializable models.
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

-keep,includedescriptorclasses class llc.pact.app.**$$serializer { *; }
-keepclassmembers class llc.pact.app.** {
    *** Companion;
}
-keepclasseswithmembers class llc.pact.app.** {
    kotlinx.serialization.KSerializer serializer(...);
}
