import UIKit

internal typealias Vector = [Double]

enum MatrixError: Error {
    case invalidVector
    case readFile
}

class Matrix: CustomDebugStringConvertible {
    var rows = 0
    var columns = 0
    internal var data = [Vector]()
    
    init() {
    }
    
    init(data: [Vector]) {
        guard let lastVector = data.last else {
            return
        }
        self.data = data
        self.rows = data.count
        self.columns = lastVector.count
    }
    
    func addVetor(vetor: Vector) throws {
        if let exsitVector = data.last {
            guard exsitVector.count == vetor.count else {
                throw MatrixError.invalidVector
            }
        } else {
            columns = vetor.count
        }
        data.append(vetor)
        rows = data.count
    }
    
    func contain(matrix: Matrix) -> Bool {
        guard
            self.columns > matrix.columns,
            self.rows > matrix.rows else {
                return false
        }
        var searchLength = matrix.rows
        for index in 0...(self.rows - matrix.rows) {
            let vectorIndex = vectorContain(vector: self.data[index], subVector: matrix.data.first)
            if vectorIndex < 0 {
                continue
            }
            searchLength -= 1
            for subIndex in 1..<matrix.rows {
                guard let subVector = generateVector(row: index + subIndex,
                                                     index: vectorIndex,
                                                     length: matrix.columns) else {
                                                        print("generate wrong")
                    return false
                }
                if (vectorEqual(vector: subVector, subVector: matrix.data[subIndex])) {
                    searchLength -= 1
                    if (searchLength == 0) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func generateVector(row: Int, index: Int, length: Int) -> Vector? {
        let endIndex = index + length - 1
        guard
            row < self.rows,
            index < self.columns,
            endIndex < self.columns else {
            return nil
        }
        var newVector = Vector()
        newVector.append(contentsOf: self.data[row][index...endIndex])
        return newVector
    }
    
    func vectorEqual(vector: Vector, subVector: Vector) -> Bool {
        guard subVector.count == vector.count else {
            return false
        }
        var isEqual = true
        for (data, subData) in zip(vector, subVector) {
            if data != subData {
                isEqual = false
            }
        }
        return isEqual
    }
    
    func vectorContain(vector: Vector, subVector: Vector?) -> Int {
        guard
            let subVector = subVector,
            subVector.count <= vector.count else {
            return -1
        }
        guard subVector.count != vector.count else {
            return vectorEqual(vector:vector, subVector:subVector)
            ? 0
            : -1
        }
        var searchLength = subVector.count
        for index in 0...(vector.count - subVector.count) {
            if (vector[index] == subVector.first) {
                for subIndex in 0..<subVector.count {
                    if (vector[index + subIndex] == subVector[subIndex]) {
                        searchLength -= 1
                        if (searchLength == 0) {
                            return index
                        }
                    }
                }
            }
        }
        return -1
    }
    
    var debugDescription: String {
        guard data.count > 0 else {
            return "Empty Matrix"
        }
        return "rows:\(rows)\n"
            + "columns:\(columns)\n"
            + "data:\n"
                + data.reduce("", { (result, vector) -> String in
                            return result + vector.reduce("", { (result, metaData) -> String in
                                return result + "\(metaData), "
                            }) + "\n"
        })
    }
}

class MatrixReader {
    
}

class MatrixTest {
    class func testInit() {
        let matrixA = Matrix(data: [[1, 2, 3],
                                    [4, 5, 6],
                                    [7, 8, 9]])
        print(matrixA)
        let matrixB = Matrix()
        do {
            try matrixB.addVetor(vetor: [3, 5, 8])
            try matrixB.addVetor(vetor: [4, 9, 82])
        } catch (_) {}
        print(matrixB)
    }
    
    class func testMath() {
        let vectorA: Vector = [1, 2, 3, 4, 5]
        let vectorB: Vector = [3, 4]
        let vectorC: Vector = [2, 9]
        let vectorD: Vector = [1, 2, 3, 4, 5]
        let vectorE: Vector = [1, 2, 4, 3, 5]
        let matrixMath = Matrix()
        print("VetorA contian B", matrixMath.vectorContain(vector: vectorA, subVector: vectorB))
        print("VetorA contian C", matrixMath.vectorContain(vector: vectorA, subVector: vectorC))
        print("VetorA contian D", matrixMath.vectorContain(vector: vectorA, subVector: vectorD))
        print("VetorA contian E", matrixMath.vectorContain(vector: vectorA, subVector: vectorE))
        print("VetorA equal B", matrixMath.vectorEqual(vector: vectorA, subVector: vectorB))
        print("VetorA equal C", matrixMath.vectorEqual(vector: vectorA, subVector: vectorC))
        print("VetorA equal D", matrixMath.vectorEqual(vector: vectorA, subVector: vectorD))
        print("VetorA equal E", matrixMath.vectorEqual(vector: vectorA, subVector: vectorE))
        let matrixA = Matrix(data: [[1, 2, 3, 4, 5],
                                     [6, 7, 8, 9, 10],
                                     [11, 12, 13, 14, 15],
                                     [16, 17, 18, 19, 20]])
        let matrixB = Matrix(data: [[32, 13, 31, 14, 32],
                                    [21, 32, 98, 42, 76],
                                    [85, 23, 87, 74, 32]])
        let matrixA1 = Matrix(data: [[2, 3, 4],
                                     [7, 8, 9]])
        let matrixA2 = Matrix(data: [[7, 8, 9, 10],
                                     [12, 13, 14, 15],
                                     [17, 18, 19, 20]])
        let matrixB1 = Matrix(data: [[31, 14, 32],
                                     [98, 42, 76]])
        let matrixB2 = Matrix(data: [[27, 12],
                                     [14, 13]])
        print("generate matrix", matrixA.generateVector(row: 0, index: 0, length: 3) as Any)
        print("generate matrix", matrixA.generateVector(row: 1, index: 2, length: 2) as Any)
        print("generate matrix", matrixA.generateVector(row: 3, index: 3, length: 2) as Any)
        print("generate matrix", matrixA.generateVector(row: 3, index: 3, length: 3) as Any)
        print("MatrixA contain A1: \(matrixA.contain(matrix: matrixA1))")
        print("MatrixA contain A2: \(matrixA.contain(matrix: matrixA2))")
        print("MatrixB contain B1: \(matrixB.contain(matrix: matrixB1))")
        print("MatrixB contain B2: \(matrixB.contain(matrix: matrixB2))")
    }
}

MatrixTest.testInit()
MatrixTest.testMath()
