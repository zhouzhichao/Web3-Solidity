在 Solidity 中，new 关键字用于在合约内部动态创建一个新的合约实例。通过 new 操作符，合约可以在运行时部署其他合约，这在需要创建多个合约实例时非常有用。新创建的合约会有一个唯一的地址，调用者可以与新合约进行交互。
使用 new 创建合约
当你使用 new 创建一个合约时，合约的构造函数会被调用，并且你可以传递构造函数所需的参数。new 返回新创建的合约的地址，允许你使用这个地址与合约进行交互。
语法
NewContract newContractInstance = new NewContract(constructorArgument1, constructorArgument2);
- NewContract 是目标合约的名称。
- newContractInstance 是新合约的实例，保存创建的新合约的地址。
- constructorArgument1, constructorArgument2 是构造函数中的参数（如果有的话）。
示例：使用 new 创建合约实例
1. 子合约 ChildContract
这是一个简单的合约，它有一个构造函数，接收一个 uint256 类型的参数，并将其存储在 value 状态变量中。
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ChildContract {
    uint256 public value;
    // 构造函数，接收一个初始值
    constructor(uint256 _value) {
        value = _value;
    }
}
- ChildContract 合约有一个 value 状态变量，它通过构造函数的参数 _value 进行初始化。
2. 父合约 ParentContract
ParentContract 合约用于动态创建 ChildContract 合约的实例，并存储这些实例的地址。
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ChildContract.sol";
contract ParentContract {
    address[] public childContracts;
    // 创建新的 ChildContract 实例
    function createChild(uint256 _value) public {
        ChildContract newChild = new ChildContract(_value); // 使用 new 关键字创建 ChildContract
        childContracts.push(address(newChild)); // 保存新合约地址到数组中
    }
    // 获取所有创建的合约地址
    function getChildContracts() public view returns (address[] memory) {
        return childContracts;
    }
}
代码说明：
1. 状态变量 childContracts：这是一个 address[] 数组，用于存储所有动态创建的 ChildContract 合约的地址。
2. createChild(uint256 _value)：该函数使用 new 关键字创建一个新的 ChildContract 实例，并传递 _value 作为构造函数参数。新合约的地址被存储在 childContracts 数组中。
3. getChildContracts()：返回所有创建的 ChildContract 合约的地址。
部署与测试
部署步骤：
1. 部署 ParentContract 合约：
  - 部署 ParentContract 合约，它将负责创建 ChildContract 合约实例。
2. 调用 createChild 函数：
  - 调用 createChild(uint256 _value)，传入一个 uint256 参数（比如 100），这将动态创建一个新的 ChildContract 实例，并将 100 传递给它的构造函数。
3. 调用 getChildContracts：
  - 调用 getChildContracts()，你可以看到通过 createChild() 函数创建的所有 ChildContract 合约的地址。
示例交互
1. 部署 ParentContract：部署父合约 ParentContract。
2. 创建子合约实例：调用 createChild(42)，这会创建一个 ChildContract 实例，初始 value 为 42。
3. 验证子合约：通过调用 getChildContracts() 得到新建的子合约地址。你可以使用 Remix 或其他工具直接与子合约进行交互，读取 value 状态变量，验证其值为 42。
完整代码
ChildContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ChildContract {
    uint256 public value;
    // 构造函数，接收一个初始值
    constructor(uint256 _value) {
        value = _value;
    }
}
ParentContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ChildContract.sol";
contract ParentContract {
    address[] public childContracts;
    // 创建新的 ChildContract 实例
    function createChild(uint256 _value) public {
        ChildContract newChild = new ChildContract(_value); // 使用 new 关键字创建 ChildContract
        childContracts.push(address(newChild)); // 保存新合约地址到数组中
    }
    // 获取所有创建的合约地址
    function getChildContracts() public view returns (address[] memory) {
        return childContracts;
    }
}
使用 new 的注意事项
1. Gas 消耗： 
  - 动态创建合约会消耗大量的 gas，因为它涉及到部署一个新合约。确保调用方有足够的 gas 进行操作。
2. 合约大小限制： 
  - 由于以太坊网络的限制，合约的字节码大小不能超过 24KB。倘若新合约非常复杂，可能会导致部署失败。
3. 合约的销毁： 
  - 创建的新合约的生命周期是独立的。如果需要销毁新创建的合约，可以通过 selfdestruct 函数在子合约中实现销毁功能。
总结
- new 关键字在 Solidity 中用于动态创建新的合约实例。
- 创建的合约实例有自己的状态、代码和地址，可以通过其地址与之交互。
- 使用 new 可以灵活地管理合约的生命周期，适用于工厂模式、代理合约等场景。