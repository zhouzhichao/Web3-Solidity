在 Solidity 中，数组（Array）是一种数据结构，用于存储相同类型的元素。数组可以是 **静态数组**（大小固定）或 **动态数组**（大小可变）。数组类型可以是基本类型（如 `uint`、`bool`、`address`）或者复杂的用户定义类型（如 `struct`）。

### 数组类型

1. **静态数组**：大小固定，初始化时确定长度，不能动态修改。
  
2. **动态数组**：大小可变，元素可以动态添加或删除。
  

### 数组的声明与初始化

1. 静态数组
  

```Solidity
// 定义一个长度为 5 的静态 uint 数组
uint[5] public staticArray;
```

- 这个数组的长度是 5，不能改变。
  

2. 动态数组
  

```Solidity
// 定义一个动态的 uint 数组
uint[] public dynamicArray;
```

- 这个数组可以根据需要动态增长或缩减。
  

### 数组的操作

1. 访问数组元素
  

数组的元素可以使用索引访问，索引从 0 开始。

```Solidity
dynamicArray[0];  // 获取数组的第一个元素
```

2. 添加元素到动态数组
  

可以使用 `push()` 向动态数组末尾添加新的元素。

```Solidity
dynamicArray.push(10);  // 向数组中添加元素 10
```

3. 删除元素
  

Solidity 提供了删除数组元素的方法，但请注意删除元素并不会缩减数组的长度，而是将该索引位置的值重置为默认值（例如对于 `uint` 类型，值为 0）。

```Solidity
delete dynamicArray[0];  // 删除第一个元素，重置为 0
```

4. 获取数组长度
  

可以使用 `.length` 获取数组的长度。

```Solidity
uint length = dynamicArray.length;  // 获取数组的长度
```

5. 清空动态数组
  

可以通过调整数组的长度来清空整个数组。

```Solidity
dynamicArray = new uint;  // 清空数组
```

### 数组的常见操作

#### 示例 1：添加、删除和访问数组元素

```Solidity
pragma solidity ^0.8.0;

contract ArrayExample {

    // 动态数组
    uint[] public numbers;

    // 添加元素到数组
    function addNumber(uint _number) public {
        numbers.push(_number);
    }

    // 获取数组中的某个元素
    function getNumber(uint index) public view returns (uint) {
        require(index < numbers.length, "Index out of bounds");
        return numbers[index];
    }

    // 删除数组中的某个元素
    function removeNumber(uint index) public {
        require(index < numbers.length, "Index out of bounds");
        delete numbers[index];  // 将数组中的该位置重置为 0
    }

    // 获取数组的长度
    function getLength() public view returns (uint) {
        return numbers.length;
    }

    // 清空数组
    function clearArray() public {
        delete numbers;  // 删除整个数组
    }
}
```

#### 示例 2：静态数组

```Solidity
pragma solidity ^0.8.0;

contract StaticArrayExample {

    // 静态数组
    uint[3] public fixedArray;

    // 设置数组中的某个元素
    function setElement(uint index, uint value) public {
        require(index < fixedArray.length, "Index out of bounds");
        fixedArray[index] = value;
    }

    // 获取数组中的某个元素
    function getElement(uint index) public view returns (uint) {
        require(index < fixedArray.length, "Index out of bounds");
        return fixedArray[index];
    }
}
```

### 二维数组

Solidity 还支持多维数组（如二维数组）。多维数组的操作与一维数组类似，只是需要更多的索引来访问元素。

#### 示例 3：二维数组

```Solidity
pragma solidity ^0.8.0;

contract MultiDimensionalArray {

    // 定义一个二维动态数组
    uint[][] public array2D;

    // 添加一个新的一维数组
    function addArray(uint[] memory newArray) public {
        array2D.push(newArray);
    }

    // 获取二维数组中的某个元素
    function getElement(uint row, uint col) public view returns (uint) {
        require(row < array2D.length, "Row index out of bounds");
        require(col < array2D[row].length, "Column index out of bounds");
        return array2D[row][col];
    }
}
```

### 内存数组与存储数组

在 Solidity 中，数组可以在 **存储**（Storage）或者 **内存**（Memory）中创建。存储数组是持久化的状态变量，而内存数组则是临时的，仅在函数调用期间存在。

1. 存储数组
  

存储数组是合约的状态变量，存储在区块链的存储中。它们的生命周期与合约相同。

```Solidity
uint[] public storageArray;  // 存储数组
```

2. 内存数组
  

内存数组是临时的，它们只在函数执行期间存在。可以在函数内创建内存数组，但长度必须在创建时指定。

```Solidity
function createMemoryArray() public pure returns (uint[] memory) {
    uint[] memory memArray = new uint[](5);  // 创建一个长度为 5 的内存数组
    memArray[0] = 1;
    memArray[1] = 2;
    // ...
    return memArray;
}
```

### 传递数组作为参数

数组可以作为函数参数传递。需要注意的是，传递存储数组和内存数组的方式不同。

#### 示例 4：传递内存数组

```Solidity
pragma solidity ^0.8.0;

contract ArrayInput {

    // 接收一个内存数组作为参数
    function sumArray(uint[] memory _array) public pure returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < _array.length; i++) {
            sum += _array[i];
        }
        return sum;
    }
}
```

#### 示例 5：传递存储数组

传递存储数组时，数组是通过引用传递的，修改会影响原数组。

```Solidity
pragma solidity ^0.8.0;

contract ArrayReference {

    uint[] public data;

    constructor() {
        data.push(1);
        data.push(2);
        data.push(3);
    }

    // 修改存储数组
    function modifyArray() public {
        uint[] storage dataArray = data;
        dataArray[0] = 42;  // 修改存储数组中的第一个元素
    }
}
```

### 总结

- **静态数组**：大小固定，声明时长度确定。
  
- **动态数组**：大小可变，可以使用 `push()` 添加元素。
  
- **内存****数组**：临时数组，只在函数执行过程中存在。
  
- **存储数组**：状态变量数组，持久化存储在区块链上。
  
- **多维数组**：支持二维、三维等多维数组，可以通过多个索引访问元素。