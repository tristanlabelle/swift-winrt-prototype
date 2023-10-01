# Swift/WinRT Prototype

Handwritten Swift-to-WinRT bindings as a proof of concept meant to inform the future code generation shape of https://github.com/tristanlabelle/swift-winrt .

# Design Decisions
## Modules
**Assembly to module mapping**: Each assembly (or group of assemblies) is mapped to a Swift module.
- **Example**: The `UWP` module maps to
- **Rationale**: Assemblies can have cyclical dependencies between internal types and form a DAG of dependencies between one another, which maps to how dependencies are handled in Swift modules.

**Qualified type names**: Swift types include a namespace prefix.
- **Example**: `WindowsStorageStreams_IBuffer`
- **Rationale**: Type names in assemblies are only unique when fully qualified by their namespace. For example, the UWP declares multiple types with the same short name.

**Namespace modules**: One Swift module is declared for each namespace of an assembly module to provide typealias shorthands.
- **Example**: `import UWP_WindowsStorageStreams`
- **Rationale**: Importing those modules mimics "using namespace" declarations in C#, makes type names shorter, makes dependencies clearer, and allows for disambiguation using module name qualification.

## Types
**typealias IFoo = any IFooProtocol**: Swift protocols generated for COM/WinRT interfaces have a "Protocol" suffix. The unsuffixed interface name is used for its existential typealias.
- **Example**: `class CustomVector: IVectorProtocol { func getView() throws -> IVectorView }`
- **Rationale**: Swift protocols are seldom needed: only when implementing COM interfaces from Swift. The existential protocols are what appear everywhere and in signatures.

## Members
**Nullability via thrown errors**: `null` return values from WinRT methods and properties of reference types are surfaced by throwing a `NullResult` error instead of marking the Swift type as optional.
- **Example**: `IVector` has `func getView() throws -> IVectorView` (not nullable)
- **Rationale**: Null return values are rare and WinRT projections already require handling exceptions so this unifies error handling.