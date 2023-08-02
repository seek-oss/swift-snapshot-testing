import Foundation
import XCTest

/// The ability to compare `Value`s and convert them to and from `Data`.
public struct Diffing<Value> {
  /// Converts a value _to_ data.
  public var toData: (Value) -> Data

  /// Produces a value _from_ data.
  public var fromData: (Data) -> Value

  /// Compares two values. If the values do not match, returns a failure message and artifacts describing the failure.
  public var diff: (Value, Value) -> (String, [DiffingArtifact<Value>])?

  /// Creates a new `Diffing` on `Value`.
  ///
  /// - Parameters:
  ///   - toData: A function used to convert a value _to_ data.
  ///   - value: A value to convert into data.
  ///   - fromData: A function used to produce a value _from_ data.
  ///   - data: Data to convert into a value.
  ///   - diff: A function used to compare two values. If the values do not match, returns a failure message and artifacts describing the failure.
  ///   - lhs: A value to compare.
  ///   - rhs: Another value to compare.
  public init(
    toData: @escaping (_ value: Value) -> Data,
    fromData: @escaping (_ data: Data) -> Value,
    diff: @escaping (_ lhs: Value, _ rhs: Value) -> (String, [DiffingArtifact<Value>])?
    ) {
    self.toData = toData
    self.fromData = fromData
    self.diff = diff
  }
}

public struct DiffingArtifact<Value> {
    /// The name of artifact type, i.e. "reference", "failure", "patch", etc.
    public var name: String?
    
    /// UTI (Uniform Type Identifier) of the payload data for an `XCTAttachment`.
    public var uniformTypeIdentifier: String
    
    /// The value of the artifact.
    public var value: Value
    
    /// Creates a new `DiffingArtifact` on `Value`.
    ///
    /// - Parameters:
    ///   - name: The name of the artifact, to be written to disk and included
    ///   as an `XCTAttachment`.
    ///   - uniformTypeIdentifier: UTI for `XCTAttachment` payload representing the artifact.
    ///   - value: The value to be written to disk and included as an `XCTAttachment` payload.
    public init(
        name: String? = nil,
        uniformTypeIdentifier: String,
        value: Value
    ) {
        self.name = name
        self.uniformTypeIdentifier = uniformTypeIdentifier
        self.value = value
    }
}
