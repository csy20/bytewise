# Flutter Engine and Plugin Registry
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# AndroidX Lifecycle (required by many plugins)
-keep class androidx.lifecycle.** { *; }
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Google Fonts - dynamic font loading
-keep class com.google.android.gms.fonts.** { *; }

# Google Play Core (In-App Updates)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.install.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Connectivity Plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Suppress warnings for missing classes
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.**
