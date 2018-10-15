# matrix

matrix is a test library to check if the matrix contains another matrix

## Usage

```
let matrixA = Matrix(data: [[1, 2, 3, 4, 5],
[6, 7, 8, 9, 10],
[11, 12, 13, 14, 15],
[16, 17, 18, 19, 20]])
let matrixA1 = Matrix(data: [[2, 3, 4],
[7, 8, 9]])
print("MatrixA contain A1: \(matrixA.contain(matrix: matrixA1))")
```
