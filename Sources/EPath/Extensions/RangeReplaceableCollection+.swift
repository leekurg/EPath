//
//  RangeReplaceableCollection+.swift
//  TextShape
//
//  Created by Илья Аникин on 27.07.2025.
//

public extension RangeReplaceableCollection where Element: Identifiable {
    /// Replace an element with *id* with new element specified by **with**.
    ///
    /// - Complexity: General complexity is **O(n^2)**.
    /// - Returns: Returns **true** when replace was successful and **false** otherwise.
    ///
    @discardableResult mutating func replace(id: Element.ID, with element: Element) -> Bool {
        guard let index = self.firstIndex(where: { $0.id == id }) else { return false }

        self.replaceSubrange(index...index, with: [element])
        return true
    }
}

public extension RangeReplaceableCollection {
    /// Replace an element with given index **at** with new element specified by **with**.
    ///
    /// - Complexity: General complexity is **O(n+1)**.
    /// - Returns: Returns **true** when replace was successful and **false** otherwise.
    ///
    mutating func replace(at index: Index, with element: Element) {
        guard index >= self.startIndex && index < self.endIndex else { return }
        self.replaceSubrange(index...index, with: [element])
    }
}
