#  Soidity 调用父函数 (Calling Parent Functions)

在 Solidity 中，子合约可以通过显式调用父合约的函数，即使子合约重写了父合约中的函数。通过 `super` 关键词，子合约可以调用父合约的同名函数，确保继承链中的所有父合约函数都被调用。

### 基本规则：

1. **重写父函数**：当子合约继承了父合约并重写了其中的函数时，必须使用 `override` 关键字来明确表示该函数是对父合约函数的重写。
  
2. **显式调用父函数**：子合约可以通过 `super.<functionName>` 或者 `ParentContract.<functionName>` 来调用父合约的函数。在多重继承中，`super` 会遵循继承链的顺序，逐步调用所有父合约中的同名函数。
  
3. **C3 线性化**：在多重继承的情况下，Solidity 使用 C3 线性化算法来确保父合约的函数调用顺序清晰且每个父函数只会被调用一次。
  

### 示例 1：单继承中调用父函数

在这个例子中，展示了如何在单继承中调用父合约的函数。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 父合约 A，包含一个可以被重写的函数
contract A {
    function doSomething() public virtual pure returns (string memory) {
        return "Called from contract A";
    }
}

// 子合约 B 继承 A，并重写 doSomething 函数
contract B is A {
    function doSomething() public pure override returns (string memory) {
        return string(abi.encodePacked(super.doSomething(), " and contract B"));
    }
}
```

#### 代码说明：

- **合约 A**：定义了一个 `doSomething` 函数，返回字符串 `"Called from contract A"`。该函数使用 `virtual` 关键字，允许子合约重写。
  
- **合约 B**：继承自合约 `A`，并重写了 `doSomething` 函数。在重写的函数中，通过 `super.doSomething()` 明确调用了父合约 `A` 中的 `doSomething` 函数，并将其返回值与 `" and contract B"` 拼接。
  

#### 测试：

部署合约 `B`，调用 `doSomething()`，返回结果应该是 `"Called from contract A and contract B"`。

### 示例 2：多重继承中调用父函数

在多重继承中，子合约可以通过 `super` 逐步调用所有父合约中的同名函数。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 父合约 A
contract A {
    function doSomething() public virtual pure returns (string memory) {
        return "Called from contract A";
    }
}

// 父合约 B
contract B is A {
    function doSomething() public virtual pure override returns (string memory) {
        return "Called from contract B";
    }
}

// 子合约 C 继承 A 和 B，并通过 super 调用父合约的函数
contract C is A, B {
    function doSomething() public pure override returns (string memory) {
        return string(abi.encodePacked(super.doSomething(), " and contract C"));
    }
}
```

#### 代码说明：

- **合约 A**：定义了一个 `doSomething` 函数，返回字符串 `"Called from contract A"`。
  
- **合约 B**：继承自合约 `A`，并重写了 `doSomething` 函数，返回字符串 `"Called from contract B"`。
  
- **合约 C**：继承自 `A` 和 `B`，并重写 `doSomething` 函数。在重写的函数中，通过 `super.doSomething()` 逐步调用父合约中的函数，并将返回值与 `" and contract C"` 拼接。
  

#### 测试：

部署合约 `C`，调用 `doSomething()`，返回结果应该是 `"Called from contract B and contract C"`。这是因为 `super` 在多继承中遵循 C3 线性化规则，首先调用 `B`，然后才调用 `A`，并且只会调用一次。

### 示例 3：显式调用父函数

在多继承中，也可以显式调用某个特定父合约的函数，而不是使用 `super`。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 父合约 A
contract A {
    function doSomething() public virtual pure returns (string memory) {
        return "Called from contract A";
    }
}

// 父合约 B
contract B is A {
    function doSomething() public virtual pure override returns (string memory) {
        return "Called from contract B";
    }
}

// 子合约 D 继承 A 和 B，并显式调用 A 和 B 的函数
contract D is A, B {
    function doSomething() public pure override returns (string memory) {
        return string(abi.encodePacked(A.doSomething(), " and ", B.doSomething(), " and contract D"));
    }
}
```

#### 代码说明：

- **合约 A**：定义了一个 `doSomething` 函数，返回字符串 `"Called from contract A"`。
  
- **合约 B**：继承自合约 `A`，并重写了 `doSomething` 函数，返回字符串 `"Called from contract B"`。
  
- **合约 D**：继承自 `A` 和 `B`，并重写了 `doSomething` 函数。在重写的函数中，显式调用了 `A.doSomething()` 和 `B.doSomething()`，并将它们的返回值拼接在一起。
  

#### 测试：

部署合约 `D`，调用 `doSomething()`，返回结果应该是 `"Called from contract A and Called from contract B and contract D"`。

### 示例 4：多继承中的函数调用顺序

在多继承中，如果父合约存在相同的函数名，Solidity 会根据 C3 线性化算法来决定函数调用的顺序。下面的例子展示了这种情况。

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 父合约 A
contract A {
    function identify() public virtual pure returns (string memory) {
        return "A";
    }
}

// 父合约 B
contract B is A {
    function identify() public virtual pure override returns (string memory) {
        return "B";
    }
}

// 父合约 C
contract C is A {
    function identify() public virtual pure override returns (string memory) {
        return "C";
    }
}

// 子合约 D 继承 B 和 C，并重写 identify 函数
contract D is B, C {
    function identify() public pure override returns (string memory) {
        return super.identify();
    }
}
```

#### 代码说明：

- **合约 A**：定义了一个 `identify` 函数，返回 `"A"`。
  
- **合约 B**：继承自 `A`，并重写了 `identify` 函数，返回 `"B"`。
  
- **合约 C**：继承自 `A`，并重写了 `identify` 函数，返回 `"C"`。
  
- **合约 D**：继承自 `B` 和 `C`，并重写了 `identify` 函数。在重写的函数中，使用 `super.identify()` 来逐步调用父合约中的 `identify` 函数。
  

#### 测试：

部署合约 `D`，调用 `identify()`，返回结果应该是 `"C"`。这是因为依据 C3 线性化规则，`C` 在继承链中最右，因此 `C` 的 `identify` 函数会被最先调用。

### 总结

- **调用父函数**：通过 `super` 或显式调用 `ParentContract.<functionName>`，子合约可以调用父合约中的函数。
  
- **`super`** **的用法**：在多重继承中，`super` 会遵循 C3 线性化顺序，确保所有父合约中的同名函数都被调用且只调用一次。
  
- **显式调用**：可以通过 `ParentContract.<functionName>` 显式调用特定父合约的函数，而不是使用 `super`。
  
- **C3 线性化**：在多继承中，Solidity 使用 C3 线性化算法来决定函数调用的顺序，确保函数调用的顺序一致且不重复。