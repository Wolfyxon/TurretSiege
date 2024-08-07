# Turret Siege

> [!IMPORTANT]
> This game is in early stages of development. Most described features may not work yet.

Open source rougelike game where you are a turret surrounded by enemies. Longer you survive, the better you score.

Made with [Love2D](https://love2d.org/) and [LovePotion](https://lovebrew.org/) in Lua.

<!-- [View on itch.io](https://wolfyxon.itch.io/turretsiege) -->

## Screenshots
TODO!

## Platforms
| Platform     | File formats     | Architectures | Status   |
| ------------ | ---------------- | ------------- | -------- |
| Universal    | `love`           | *             | ✅       |
| Linux        | `AppImage`       | x86_64        | ✅       |
| Windows      | `exe`            | x86_64 x86_32 | ✅✅     |
| Nintendo 3DS | `3dsx` ~~`cia`~~ |               | ⚠️📁     |
| MacOS        |                  |               | 📁       |
| Android      |                  |               | 📁       |

✅ `supported` | ⚠️ `unstable` | ❌ `unsupported` | 🕛 `in progress` | 📁 `planned` 

[Downloads]()

## Building and debugging
### With the Makefile (recommended)
This project uses [Love2D Universal](https://github.com/Wolfyxon/love2d-universal). Refer to the [wiki](https://github.com/Wolfyxon/love2d-universal/wiki/Building-your-project) for instructions.

### Running manually

To test the game without using the Makefile with `love`, start a terminal in the repository directory then run:
```
love src
```

### Manual building
Refer to the [Love2D wiki](https://love2d.org/wiki/Game_Distribution) and [LovePotion wiki](https://lovebrew.org/#/packaging?id=fused-binary).

### LovePotion bundler
You may use the [LovePotion bundler](https://bundle.lovebrew.org/) for Nintendo consoles but it's not officially supported and will require making a config file.
