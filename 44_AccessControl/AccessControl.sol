/**
实现一个简化版本的访问控制合约，包含以下功能：

定义两个角色：admin和user
实现分配和撤销角色的函数
为合约部署者分配admin角色
**/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    // 定义角色的常量
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    // 角色管理映射
    mapping(bytes32 => mapping(address => bool)) private _roles;

    // 事件
    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);

    // 构造函数：将合约部署者设置为 admin 角色
    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    // 修饰符：限制只有具有某个角色的账户可以调用
    modifier onlyRole(bytes32 role) {
        require(_hasRole(role, msg.sender), "AccessControl: insufficient privileges");
        _;
    }

    // 检查账户是否拥有某个角色
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }

    // 授予角色（只有 admin 可以调用）
    function grantRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _grantRole(role, account);
    }

    // 撤销角色（只有 admin 可以调用）
    function revokeRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _revokeRole(role, account);
    }

    // 内部函数：授予角色
    function _grantRole(bytes32 role, address account) internal {
        require(!_roles[role][account], "AccessControl: account already has role");
        _roles[role][account] = true;
        emit RoleGranted(role, account);
    }

    // 内部函数：撤销角色
    function _revokeRole(bytes32 role, address account) internal {
        require(_roles[role][account], "AccessControl: account does not have role");
        _roles[role][account] = false;
        emit RoleRevoked(role, account);
    }

    // 检查账户是否有某个角色
    function _hasRole(bytes32 role, address account) internal view returns (bool) {
        return _roles[role][account];
    }
}