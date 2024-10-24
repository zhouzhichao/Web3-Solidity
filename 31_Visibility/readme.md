# Solidity 可见性 (Visibility)

在 Solidity 中，函数和状态变量的**可见性**决定了它们在合约内部和外部的访问权限。可见性修饰符控制了如何以及从哪里可以调用这些函数或访问这些变量。Solidity 提供了四种可见性修饰符：

1. `public`
  
2. `internal`
  
3. `private`
  
4. `external`
  

### 1. `public`（公共）

- **函数**：可以从任何地方调用，包括：
  - 合约的外部（通过交易）。
    
  - 合约的内部（通过内部调用）。
    
  - 继承合约（通过继承关系）。
    
- **状态变量**：自动生成一个与状态变量同名的“getter”函数，可以从外部访问该变量的值。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Example {
    uint public value = 100; // 自动生成getter函数

    // public函数可以从内部和外部访问
    function setValue(uint _value) public {
        value = _value;
    }
}
```

- `value` 是一个 `public` 状态变量，Solidity 会自动生成一个 `value()` 函数来返回该变量的值。
  
- `setValue` 是一个 `public` 函数，可以从合约内部或外部调用来设置 `value`。
  

### 2. `internal`（内部）

- **函数**：只能在当前合约和继承的子合约中调用，不能从合约外部访问。
  
- **状态变量**：只能在当前合约和继承的子合约中访问，不能通过外部调用访问。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Base {
    uint internal value = 100;

    function setValue(uint _value) internal {
        value = _value;
    }
}

contract Derived is Base {
    function updateValue(uint _value) public {
        setValue(_value); // 可以在子合约中调用 internal 函数
    }

    function getValue() public view returns (uint) {
        return value; // 可以在子合约中访问 internal 状态变量
    }
}
```

- `setValue` 是一个 `internal` 函数，不能从外部调用，但可以在继承的子合约 `Derived` 中调用。
  
- `value` 是一个 `internal` 状态变量，也只能在当前合约 `Base` 和子合约 `Derived` 中访问。
  

### 3. `private`（私有）

- **函数**：只能在当前合约内部调用，不能在子合约中调用，也不能从外部访问。
  
- **状态变量**：只能在当前合约内部访问，不能在子合约或外部调用访问。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Example {
    uint private value = 100;

    function setValue(uint _value) private {
        value = _value;
    }

    function updateValue(uint _value) public {
        setValue(_value); // 可以在合约内部调用 private 函数
    }

    function getValue() public view returns (uint) {
        return value; // 可以在合约内部访问 private 状态变量
    }
}
```

- `setValue` 是一个 `private` 函数，不能从合约外部调用，也不能在继承的子合约中调用，只能在当前合约内部使用。
  
- `value` 是一个 `private` 状态变量，不能从外部或子合约中访问。
  

### 4. `external`（外部）

- **函数**：只能从合约外部调用，不能通过内部调用访问，但可以使用 `this.函数名()` 进行内部调用。
  
- **状态变量**：状态变量不能设置为 `external`，它仅适用于函数。
  

#### 示例：

```Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Example {
    function externalFunction() external pure returns (string memory) {
        return "External function called";
    }

    function callExternalFunction() public view returns (string memory) {
        // this.externalFunction() 允许在内部调用 external 函数
        return this.externalFunction();
    }
}
```

- `externalFunction` 是一个 `external` 函数，不能在合约内部直接调用，但可以通过 `this.externalFunction()` 进行内部调用。
  
- `callExternalFunction` 函数中，我们通过 `this.externalFunction()` 来调用 `externalFunction`，这会创建一个实际的外部调用（消耗更多的 gas）。
  

### 可见性总结

<style><!--br {mso-data-placement:same-cell;}--> td {white-space:nowrap;border:1px solid #dee0e3;font-size:10pt;font-style:normal;font-weight:normal;vertical-align:middle;word-break:normal;word-wrap:normal;}</style><byte-sheet-html-origin data-id="" data-version="4" data-is-embed="true" data-grid-line-hidden="false" data-copy-type="col"><table style="border-collapse: collapse;"><colgroup><col width="105"><col width="105"><col width="105"><col width="105"><col width="105"></colgroup><tbody><tr height="76"><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">修饰符</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">内部调用</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">外部调用</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">子合约调用</td><td style="color:rgb(0, 0, 0);font-size:12pt;font-weight:bold;text-align:center;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">自动生成 getter（状态变量）</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">public</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">internal</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td></tr><tr height="31"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">private</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td></tr><tr height="53"><td style="color:rgb(0, 0, 0);word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">external</td><td data-sheet-value="[{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;❌ (除非使用 &quot;},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;this&quot;,&quot;style&quot;:{&quot;font&quot;:&quot;10pt/1.5 MonospacedNumber, LarkHackSafariFont, LarkEmojiFont, LarkChineseQuote, -apple-system, BlinkMacSystemFont, \&quot;Helvetica Neue\&quot;, Tahoma, \&quot;PingFang SC\&quot;, \&quot;Microsoft Yahei\&quot;, Arial, \&quot;Hiragino Sans GB\&quot;, sans-serif, \&quot;Apple Color Emoji\&quot;, \&quot;Segoe UI Emoji\&quot;, \&quot;Segoe UI Symbol\&quot;, \&quot;Noto Color Emoji\&quot;&quot;,&quot;foreColor&quot;:&quot;rgb(0, 0, 0)&quot;}},{&quot;type&quot;:&quot;text&quot;,&quot;text&quot;:&quot;)&quot;}]" style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌ (除非使用 this)</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">✅</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td><td style="color:rgb(0, 0, 0);font-size:12pt;word-wrap:break-word;word-break:break-word;white-space:pre-wrap;">❌</td></tr></tbody></table></byte-sheet-html-origin>

### 可见性修饰符的适用场景

1. **`public`**：适用于需要在外部和内部频繁使用的函数和状态变量。例如，用户交互函数通常是 `public` 的。
  
2. **`internal`**：适用于只需要在合约内部或继承合约中使用的函数或变量。如果不希望函数被外部调用，但希望继承的子合约能够调用它，则使用 `internal`。
  
3. **`private`**：适用于只需要在当前合约中使用的函数或变量。如果不希望子合约或外部合约访问这些函数或变量，则使用 `private`。
  
4. **`external`**：适用于只需要从外部调用的函数，尤其是那些不需要被内部调用的函数。不过在某些情况下，可以通过 `this` 进行内部调用。
  

### 注意事项

- **状态变量默认可见性**：状态变量的默认可见性是 `internal`，如果没有显式声明可见性修饰符，状态变量将只能在当前合约和继承的子合约中访问。
  

```Solidity
uint value; // 等同于 uint internal value;
```

- **函数默认可见性**：函数的默认可见性是 `public`，如果没有显式声明可见性修饰符，函数将可以从合约的内部和外部调用。
  

```Solidity
function example() {    // 等同于 function example() public;}
```

### 总结

- **`public`**：任何地方都可以调用（包括外部、内部和继承合约）。
  
- **`internal`**：只能从当前合约和继承的子合约内部调用。
  
- **`private`**：只能在当前合约内部调用。
  
- **`external`**：只能从外部调用，内部调用需要通过 `this` 关键字。