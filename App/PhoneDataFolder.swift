import Foundation

// The saved playlist, its analysis, and every run record live here. The folder keeps the app's
// first name, Samadhi, because the phone holds the only copy of that data and a rename would
// strand it. The bundle identifier stays com.samaydhawan.Samadhi for the same reason.
enum PhoneDataFolder {
    static let name = "Samadhi"

    static var url: URL {
        let base =
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return base.appending(path: name, directoryHint: .isDirectory)
    }
}
