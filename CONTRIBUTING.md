# Contributing

> [!IMPORTANT]  
> All contributions related to the **Makefile** should be made in https://github.com/Wolfyxon/love2d-universal

## Submissions
You may use [issues](https://github.com/Wolfyxon/TurretSiege/issues) to submit bugs or propose changes and new features.
You can open a new issue [here](https://github.com/Wolfyxon/TurretSiege/issues/new/choose), and pick a form matching your submission.

## Writing code
If you'd like to contribute to the project by directly writing code, [fork this repository](https://github.com/Wolfyxon/TurretSiege/fork), then commit your changes there. After that, open a [pull request](https://github.com/Wolfyxon/TurretSiege/pulls), then your changes will be reviewed.

### Guidelines
#### Commits

Please make commit names that actually explain your changes.

Good:
- Added fireProjectile()
- Fixed update() not running if the parent node is a Sprite
- Added RocketProjectile

Ok:
- Added new projectiles
- Fixed destroy()

Bad:
- Source code update
- Update
- Fixed bugs
- Menu update

#### Single-task focus
Please avoid creating pull requests that introduce multiple unrelated changes.
You should only make changes focused on one thing. You can split your pull request by committing changes to multiple branches then submitting PRs for each.

Bad examples:
- Add 2 new projectiles + fix performance
- Improve texture quality and add error handling

#### Style
Please follow the project's code style.
```lua
local variable = "string"

local dictionaryTable = {
    key1 = "value",
    key2 = 1234
}

local shortListTable = {"a", "b", "c", "d"}

local longListTable = {
    "Rise and shine mr. Freeman.",
    "Rise and... shine.",
    "Not that I wish to imply you have been sleeping on the job."
}

local math = a + b * 3

---@class SomeClass
local SomeClass = {}
```
Do **not** do things like:
```lua
local bad_variable = 'string'
local VariableThatIsNotAClass = 12345

local badMath = a+b*3
```

#### Documentation
Function parameters, function return values and class properties, must be typehinted using [LuaDoc](https://keplerproject.github.io/luadoc/manual.html).

```lua
---@param a number
---@param b number
---@return number
function add(a, b) 
    return a + b
end
```

```lua

---@class CoolClass: BaseClass
local CoolClass = BaseClass:new()

CoolClass.someProperty = 123             ---@type number
CoolClass.name = "Friderick von Fazbear" ---@type string
```

#### Independence
Avoid adding any third-party unless necessary.

When making this project I wanted to create most the environment from the ground up and only rely on **Love2D** as the base engine.

#### Readability and openness
Do not obfuscate or precompile your code.

The code you write must be readable and open source.