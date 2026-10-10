# Aperture

Open-source iOS app that registers a Locked Camera Capture extension so the
**Camera Control** button (iPhone 16+, iOS 18+) can be assigned to it. Pressing it
hands off to the main app, which then:

1. opens a chosen app (URL scheme),
2. runs a Shortcut by name, or
3. shows a quick-launcher grid of 4-8 apps.

## Build + install from Windows (all free)

1. Create a **public** GitHub repo (free macOS CI minutes) and upload everything in this folder,
   including the hidden `.github` folder (GitHub Desktop or `git push` is easiest).
2. Open the repo's **Actions** tab. The *Build unsigned IPA* workflow runs on push
   (or press *Run workflow*). When it finishes, download the `Aperture-ipa` artifact and unzip it.
3. Install **Sideloadly** on Windows (it needs iTunes + iCloud from apple.com, not the Microsoft Store versions).
   Drag `Aperture.ipa` in, sign in with a free Apple ID, press Start.
   (AltStore / SideStore also work.)
4. On the iPhone: Settings > Privacy & Security > Developer Mode (on), and trust your profile under
   General > VPN & Device Management.
5. Settings > Camera > Camera Control > pick **Aperture**.

Free Apple IDs expire sideloaded apps every 7 days, so re-sign weekly.

## Notes

- iOS has no API to list installed apps or Shortcuts. Apps come from a preset URL-scheme list
  (`Aperture/Models.swift`) or a custom scheme; Shortcuts are typed by name.
- New URL schemes must also be added to `LSApplicationQueriesSchemes` in `project.yml`
  for the "installed" dimming to work (opening them works regardless).
- The extension reads no settings (no App Group needed), which keeps free-account signing simpler.

## If the extension isn't picked up

The extension's Info.plist (`EXExtensionPointIdentifier: com.apple.lockedcamera-capture`) and product
type were written without Xcode to test against. If Aperture doesn't appear under Camera Control,
compare against Apple's "Capturing photos from the Lock Screen" sample project.
