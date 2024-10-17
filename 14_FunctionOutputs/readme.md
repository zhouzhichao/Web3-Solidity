# solidity 函数输出 (Function Outputs)
在 **Solidity** 中，函数可以返回一个或多个值，这些值称为 **函数输出**。函数输出的类型可以是基本类型（如 `uint`、`bool`、`address`）或复杂类型（如结构体、数组、映射等）。函数输出可以通过 `returns` 关键字来定义。

### 基本语法

```Solidity
function functionName(参数类型 参数名称, ...) public view returns (返回类型) {
    // 函数逻辑
    return 返回值;
}
```

- **`returns`**：定义函数的返回类型，支持返回单个值或多个值。
  
- **`return`**：用于在函数体内返回值。
  

### 示例 1：返回单个值

```Solidity
pragma solidity ^0.8.0;

contract SingleReturn {
    // 返回一个 uint 类型的值
    function getNumber() public pure returns (uint) {
        return 42;
    }
}
```

#### 解释：

- **`returns (uint)`**：表示函数返回一个 `uint` 类型的值。
  
- **`return 42`**：直接返回 `42`。
  

### 示例 2：返回多个值

Solidity 函数可以返回多个值，返回多个值时使用 **逗号分隔**。

```Solidity
pragma solidity ^0.8.0;

contract MultipleReturns {
    // 返回一个 uint 和一个 bool
    function getValues() public pure returns (uint, bool) {
        return (42, true);
    }
}
```

#### 解释：

- **`returns (uint, bool)`**：表示函数返回两个值，分别是 `uint` 和 `bool`。
  
- **`return (42, true)`**：返回两个值，`42` 和 `true`。
  

### 示例 3：命名返回值

Solidity 允许为返回值命名，这样可以在函数中直接给返回值赋值，避免使用 `return` 语句。

```Solidity
pragma solidity ^0.8.0;

contract NamedReturns {
    // 返回一个 uint 和一个 bool，返回值命名为 result 和 flag
    function getValues() public pure returns (uint result, bool flag) {
        result = 42;
        flag = true;
        // 不需要 return 语句，返回值会自动返回
    }
}
```

#### 解释：

- **`returns (uint result, bool flag)`**：为返回值命名为 `result` 和 `flag`。
  
- 可以直接给返回值赋值，函数结束时自动返回这些值，无需显式 `return`。
  

### 示例 4：返回结构体

Solidity 支持返回复杂类型，比如结构体（`struct`）。

```Solidity
pragma solidity ^0.8.0;

contract StructReturn {
    struct Person {
        string name;
        uint age;
    }

    Person public person;

    constructor() {
        person = Person("Alice", 30);
    }

    // 返回一个结构体
    function getPerson() public view returns (Person memory) {
        return person;
    }
}
```

#### 解释：

- **`returns (Person memory)`**：返回一个在内存中的 `Person` 结构体。
  
- **`return person`**：返回存储在状态变量中的 `person`。
  

### 示例 5：返回数组

函数也可以返回动态数组或静态数组。

```Solidity
pragma solidity ^0.8.0;

contract ArrayReturn {
    uint[] public numbers;

    constructor() {
        numbers.push(1);
        numbers.push(2);
        numbers.push(3);
    }

    // 返回一个动态数组
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}
```

#### 解释：

- **`returns (uint[] memory)`**：返回一个在内存中的 `uint` 类型的动态数组。
  
- **`return numbers`**：返回存储在状态变量中的 `numbers` 数组。
  

### 函数输出的使用

- **单个返回值**：可以直接赋值给一个变量。
  
- **多个返回值**：可以使用多个变量来接收。
  

#### 示例 6：接收返回值

```Solidity
pragma solidity ^0.8.0;

contract UseReturnValues {
    function getTwoValues() public pure returns (uint, bool) {
        return (42, true);
    }

    function useValues() public pure returns (uint, bool) {
        // 使用多个变量接收返回值
        (uint number, bool flag) = getTwoValues();
        return (number, flag);
    }
}
```

#### 解释：

- **`(uint number, bool flag) = getTwoValues();`**：通过解构方式接收 `getTwoValues` 函数的返回值。
  

### 返回值的注意事项

1. **内存****与存储**：
  1. 当返回结构体或数组时，必须明确指定数据位置为 `memory` 或 `storage`（通常返回 `memory` 类型的数据）。
    

```Solidity
function getArray() public view returns (uint[] memory) {
    return numbers; // 返回数组时指定为 memory
}
```

1. **返回类型的限制**：
  1. 函数不能返回映射（`mapping`）类型，因为映射是引用类型，无法直接返回。
    
2. **命名返回值**：
  1. 命名返回值时，返回值在函数中自动初始化为零值。如果函数执行完毕时没有显式返回，这些命名返回值会自动返回。
    

### 总结

- **函数输出** 使用 `returns` 关键字声明，可以返回单个或多个值。
  
- 可以返回基本类型、结构体、数组等复杂类型，但不能返回映射。
  
- **命名返回值** 可以自动返回，无需显式使用 `return` 语句。
  
- 函数返回复杂数据类型时，需要指定数据位置（如 `memory` 或 `storage`），通常使用 `memory`。