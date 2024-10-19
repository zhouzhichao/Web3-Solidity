# Solidity 映射

在 Solidity 中，**映射**（mapping）是一种用于存储键值对的数据结构，类似于其他编程语言中的哈希表或字典。映射可以将一个键（key）映射到一个特定的值（value）。映射在智能合约中非常有用，因为它们允许高效的键值查找。

### 映射的声明与使用

映射的基本声明语法如下：

```Solidity
mapping(键类型 => 值类型) visibility 名称;
```

- **键类型**：可以是任何基本类型，比如 `uint`, `address`, `bytes32` 等，但不能是复杂类型如映射、动态数组、合约等。
  
- **值类型**：可以是任意类型，包括结构体、数组、映射等。
  
- **visibility**：可见性修饰符，通常是 `public` 或 `private`。
  

### 示例 1：简单的映射

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleMapping {
    // 定义一个映射，将地址映射到 uint 值
    mapping(address => uint) public balances;

    // 设置某个地址的余额
    function setBalance(address _address, uint _balance) public {
        balances[_address] = _balance;
    }

    // 获取某个地址的余额（如果使用了 public，Solidity 自动生成了 getter 函数）
    function getBalance(address _address) public view returns (uint) {
        return balances[_address];
    }
}
```

#### 解释：

- **`mapping(address => uint)`**：这是一个将 `address` 类型映射到 `uint` 类型的映射，通常用于存储余额等信息。
  
- **`balances`**：这个映射存储了每个地址的余额。
  
- **`setBalance`**：设置某个地址的余额。
  
- **`getBalance`**：获取某个地址的余额。虽然 `balances` 被声明为 `public`，Solidity 会自动生成一个可以查询余额的 getter 函数，但我们也可以显式定义一个 `getBalance` 函数。
  

### 映射的特点

- **不存在的键值**：如果查询一个尚未设置的映射键，映射会返回其值类型的默认值。例如，如果映射 `balances` 中没有存储某个地址的余额，则返回 `uint` 的默认值 `0`。
  
- **不可遍历**：映射不能像数组那样遍历。也就是说，映射中的键是不可枚举的，不能直接获取所有键的列表。
  
- **键的不可删除性**：虽然映射中的值可以通过 `delete` 关键字删除，但键本身不能删除。`delete` 只会将值重置为默认值。
  

### 示例 2：删除映射中的值

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MappingDeletion {
    // 定义一个映射，将地址映射到 uint 值
    mapping(address => uint) public balances;

    // 设置某个地址的余额
    function setBalance(address _address, uint _balance) public {
        balances[_address] = _balance;
    }

    // 删除某个地址的余额
    function deleteBalance(address _address) public {
        delete balances[_address];
    }
}
```

#### 解释：

- **`delete balances[_address]`**：删除地址 `_address` 对应的余额，将其重置为 `0`。在 Solidity 中，`delete` 操作只是将值重置为默认值，不会删除映射中的键。
  

### 示例 3：嵌套映射

映射可以作为值的类型来嵌套使用，这样可以创建多级映射。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NestedMapping {
    // 定义一个嵌套映射，将一个地址映射到另一个地址的余额
    mapping(address => mapping(address => uint)) public allowances;

    // 设置两个地址之间的允许额度
    function setAllowance(address owner, address spender, uint amount) public {
        allowances[owner][spender] = amount;
    }

    // 获取两个地址之间的允许额度
    function getAllowance(address owner, address spender) public view returns (uint) {
        return allowances[owner][spender];
    }

    // 删除两个地址之间的允许额度
    function deleteAllowance(address owner, address spender) public {
        delete allowances[owner][spender];
    }
}
```

#### 解释：

- **`mapping(address => mapping(address => uint))`**：这是一个嵌套映射，允许将一个地址映射到另一个地址的余额。常见的应用场景是代币合约中的 `allowance` 机制。
  
- **`allowances`**：这是一个嵌套映射，保存每个地址对另一个地址的允许额度。
  
- **`setAllowance`**：设置两个地址之间的可用额度。
  
- **`getAllowance`**：查询两个地址之间的可用额度。
  
- **`deleteAllowance`**：删除两个地址之间的可用额度，将其重置为 `0`。
  

### 示例 4：映射与结构体

映射可以将键映射到结构体（`struct`），这使得可以存储更复杂的数据。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructMapping {

    // 定义一个结构体
    struct Person {
        string name;
        uint age;
    }

    // 将地址映射到 Person 结构体
    mapping(address => Person) public people;

    // 设置某个地址对应的 Person 信息
    function setPerson(address _address, string memory _name, uint _age) public {
        people[_address] = Person(_name, _age);
    }

    // 获取某个地址对应的 Person 信息
    function getPerson(address _address) public view returns (string memory, uint) {
        Person memory person = people[_address];
        return (person.name, person.age);
    }

    // 删除某个地址对应的 Person 信息
    function deletePerson(address _address) public {
        delete people[_address];
    }
}
```

#### 解释：

- **`mapping(address => Person)`**：这是一个将地址映射到 `Person` 结构体的映射。
  
- **`setPerson`**：设置某个地址对应的 `Person` 信息，包括名字和年龄。
  
- **`getPerson`**：获取某个地址对应的 `Person` 信息。
  
- **`deletePerson`**：删除某个地址对应的 `Person` 信息，将其重置为默认值（空字符串和 `0`）。
  

### 映射的限制

1. **不能遍历**：映射中的键是不能被枚举的，无法通过 Solidity 内置机制获取映射中所有键的列表。如果需要遍历映射中的键，可以通过维护一个数组来存储所有添加的键。
  
2. **键类型的限制**：映射的键类型必须是基本类型，如 `uint`、`address`、`bytes32` 等。不能使用复杂类型作为键，例如映射、动态数组或结构体。
  
3. **不支持长度属性**：映射不像数组一样有 `.length` 属性，无法获取映射的长度。
  

### 总结

- **映射** 是 Solidity 中用于存储键值对的核心数据结构，适用于需要高效查找和更新键值对的场景。
  
- **特点**：映射可以存储任意类型的值（包括结构体、数组、其他映射），但键必须是基本类型。映射中的键不能被枚举，且删除某个键只会重置其值为默认值。
  
- **应用场景**：映射广泛用于合约中的账户余额管理、权限管理、数据查找等场景。