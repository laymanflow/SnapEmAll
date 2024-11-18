# SnapEmAll: Wildlife Exploration App

**SnapEmAll** is an application designed for wildlife enthusiasts and researchers to document and explore their animal discoveries. With SnapEmAll, users can capture photos of animals, log their findings in a photo gallery, and explore species information in the Snappidex.

---

## Features

### Wildlife Photography and Logging
- Capture photos and log your discoveries in an organized gallery.

### Snappidex
- A database of over 100 species, complete with detailed animal information.
- Discover new animals and review key species data.

### Cloud Syncing
- Securely save and access your photos and logs across devices.

### Account Verification
- Create an account using your phone number, verified via SMS.

---

## Installation Guide

**Note:** This app was developed in Swift using Xcode. To run the app, you must have:

- An Apple device (macOS for development, iPhone for testing).
- Xcode installed on your macOS system.

### Steps to Download and Run the App

1. **Install Xcode**:
   - Download Xcode from the Mac App Store.

2. **Decompress the Project Files**:
   - Extract the contents of the provided `.zip` file.
   - Locate and open the `SnapEmAll.xcodeproj` file to load the project in Xcode.

3. **Set Up Signing and Capabilities**:
   - Navigate to the Project Settings page in Xcode.
   - Under **Signing and Capabilities**, link your Apple ID to Xcode.
   - Register yourself as a **Personal Team** (required for building the project).

4. **Testing Environment**:
   - Use Xcode’s built-in simulator or connect an iPhone to your Mac.
   - Install the required iOS simulator (if using the built-in option).
   - **Recommended**: Use a real iPhone to simulate all features properly, as a camera is required.

5. **Build and Run the Project**:
   - Perform a full build of the project:
     - Use `Cmd + B` to build.
     - Use `Cmd + R` to run.

---

## Usage Guide

### Sign In
1. Launch the app. 
2. The first screen will prompt you to sign in or create an account.
3. Enter your phone number (e.g., `+1` format: `+13150001111`).
4. A verification code will be sent to your phone.
5. Enter the code to complete the process. 
6. Once verified, your phone number will be registered as your account.

### Home Screen
After signing in, you’ll be directed to the home view. Available options:
- **Camera**: Take wildlife photos.
- **Gallery**: View your captured photos.
- **Snappidex**: Explore species information.
- **Settings**: Adjust app preferences.

---

## App Features

### Camera
- Use the camera to capture photos of animals.

### Gallery
- View all your logged photos.
- Tap a photo to see it enlarged.
- Click the **Log Animal** button to store your animal in the **Discovered** section of the Snappidex.

### Snappidex
- Browse the database of animals.
- View species you've discovered and those yet to be found.
- Access detailed animal information for each species.

### Settings
Adjust app preferences:
1. **Account Settings**: Change your username or delete all photos and discovered animals.
2. **Accessibility Settings**: Enable dark mode and adjust text size.
3. **Camera Settings**: Open Apple camera settings for SnapEmAll.
4. **Notification Settings**: Open Apple notification settings for SnapEmAll.

---

## Admin Permissions

1. **Admin Promotion**: Any user can be promoted to an administrator via the database.
2. **Admin Capabilities**:
   - View all user content.
   - Make changes to the logged animals within each account.
   - Manage the animal database in the Snappidex, including adding or removing species.

--- 

**SnapEmAll** provides a seamless and secure platform for wildlife enthusiasts to capture, log, and learn about animals. Start your wildlife exploration journey today!
