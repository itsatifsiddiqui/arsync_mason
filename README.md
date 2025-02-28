# Arsync Solutions Templates

A collection of open-source Mason bricks created for Flutter development for Arsync Solutions.

## Overview

This repository contains reusable bricks that help accelerate Flutter development by providing ready-to-use templates for common features and project structures.

---

| Brick | Description |
| ----- | ----------- |
| [arsync_firebase_auth](arsync_firebase_auth) | Firebase authentication features including email, Google, Apple login, and more |
| [arsync_project](arsync_project) | Project structure template for Arsync projects |

## Getting Started

Make sure you have the [Mason CLI](https://pub.dev/packages/mason_cli) installed:

```bash
# Install Mason CLI
dart pub global activate mason_cli
```
## Bricks

### arsync_project

A brick for setting up an Arsync project structure with predefined folders and configurations.

[View Documentation](arsync_project/README.md)

### arsync_firebase_auth

A brick for setting up Firebase Authentication with various providers.

**Features:**
- Email signup and login
- Google authentication
- Apple authentication
- Phone authentication
- Passwordless email authentication
- Forgot password functionality
- Email verification
- Change password functionality

[View Documentation](arsync_firebase_auth/README.md)



### Using Bricks



#### Option 1: Add Bricks Globally

To install bricks globally on your machine:

```bash
# Add the firebase auth brick globally
mason add -g arsync_firebase_auth --git-url https://github.com/itsatifsiddiqui/arsync_mason.git --git-path arsync_firebase_auth

# Add the project brick globally
mason add -g arsync_project --git-url https://github.com/itsatifsiddiqui/arsync_mason.git --git-path arsync_project

# Use the bricks from any directory
mason make arsync_firebase_auth
mason make arsync_project

```

#### Option 2: Clone the Repository

Clone this repository and use the bricks directly:

```bash
git clone https://github.com/itsatifsiddiqui/arsync_mason.git
cd arsync_mason

# Get all dependencies
mason get

# Generate code with the arsync_firebase_auth brick
mason add arsync_firebase_auth --path <path_to_cloned_repo>/arsync_firebase_auth

# Generate code with the arsync_project brick
mason add arsync_project --path <path_to_cloned_repo>/arsync_firebase_auth
```

### Managing Bricks

#### List Installed Bricks

View all installed bricks:

```bash
# List local bricks
mason list
# List global bricks
mason ls -g
```



## Author

**Atif Siddiqui**
- Email: itsatifsiddiqui@gmail.com
- GitHub: [itsatifsiddiqui](https://github.com/itsatifsiddiqui)
- LinkedIn: [Atif Siddiqui](https://www.linkedin.com/in/atif-siddiqui-213a2217b/)


## About Arsync Solutions

[Arsync Solutions](https://arsyncsolutions.com), We build Flutter apps for iOS, Android, and the web.

