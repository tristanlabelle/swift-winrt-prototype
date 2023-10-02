# Swift/WinRT Prototype

Handwritten Swift-to-WinRT bindings as a proof of concept meant to inform the future code generation shape of [swift-winrt](https://github.com/tristanlabelle/swift-winrt).

# Design Decisions
## Modules and Namespaces
### Assembly to module mapping
Each assembly (or group of assemblies) is mapped to a Swift module.

**Rationale**: Assemblies can have cyclical dependencies between internal types and form a DAG of dependencies between one another, which maps to how dependencies are handled in Swift modules.

**Example**: The `UWP` module maps to the `Windows.winmd` union metadata assembly.

### Qualified type names
Swift types include a namespace prefix.

**Rationale**: Type names in assemblies are only unique when fully qualified by their namespace. For example, the UWP declares multiple types with the same short name.

**Example**: `WindowsStorageStreams_IBuffer`

### Namespace modules
One Swift module is declared for each namespace of an assembly module to provide typealias shorthands.

**Rationale**: Importing those modules mimics "using namespace" declarations in C#, makes type names shorter, makes dependencies clearer, and allows for disambiguation using module name qualification.

**Example**: `import UWP_WindowsStorageStreams`

## Type Projections
## Enums as structs
WinRT enums are projected as `Hashable` structs wrapping an Int32 value, instead of as enums. These structs implement `OptionSet` if the underlying enum has the `[Flags]` attribute.

**Rationale**: WinRT does not enforce that instances of enum types have a value that matches one of the enumerants.

**Example**:
```swift
public struct AsyncStatus: Hashable {
    public var value: Int32
    public init(_ value: Int32 = 0) { self.value = value }

    public static let started = Self(0)
    public static let completed = Self(1)
    public static let canceled = Self(2)
    public static let error = Self(3)
}
```

### IFoo and IFooProtocol naming
Swift protocols generated for COM/WinRT interfaces have a "Protocol" suffix. The unsuffixed interface name is used for its existential typealias.

**Rationale**: We only need to refer to Swift protocols when implementing COM interfaces from Swift, whereas existential protocols appear everywhere in signatures. This also keeps signatures very similar to C#.

**Example**: `typedef IClosable = any IClosableProtocol`

**Example**: `class CustomVector: IVectorProtocol { func getView() throws -> IVectorView }`

## Members
### Property setters as functions
Property setters are exposed as functions taking a new value argument and returning `Void`, instead of as property setters.

**Rationale**: Swift does not support throwing property setters, and we don't want to ignore or failfast on exceptions. WinRT should not overload properties to methods whereas Swift can, so this is safe.

**Example**:
```swift 
// In IAsyncAction
var completed: AsyncActionCompletedHandler { get throws }
func completed(_ value: AsyncActionCompletedHandler!) throws
```

### Nullability via thrown errors
`null` return values from WinRT methods and properties of reference types are surfaced by throwing a `NullResult` error instead of marking the Swift type as optional.

**Rationale**: Null return values are rare and WinRT projections already require handling exceptions so this unifies error handling.

**Example**: `IVector` has `func getView() throws -> IVectorView` (not nullable)