// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VehicleRegistry {
    
    // 定义车辆的结构体
    struct Vehicle {
        string make;     // 制造商（字符串类型）
        uint year;       // 生产年份（整数类型）
        address owner;   // 车辆所有者（地址类型）
    }

    // 存储所有车辆的数组
    Vehicle[] public vehicles;

    // 添加新车辆
    function addVehicle(string memory _make, uint _year) public {
        // 创建并插入新的车辆记录
        vehicles.push(Vehicle({
            make: _make,
            year: _year,
            owner: msg.sender
        }));
    }

    // 获取车辆信息
    function getVehicle(uint index) public view returns (string memory make, uint year, address owner) {
        require(index < vehicles.length, "Invalid vehicle index");
        Vehicle memory vehicle = vehicles[index];
        return (vehicle.make, vehicle.year, vehicle.owner);
    }

    // 修改特定车辆的年份
    function updateVehicleYear(uint index, uint _year) public {
        require(index < vehicles.length, "Invalid vehicle index");
        Vehicle storage vehicle = vehicles[index];
        require(vehicle.owner == msg.sender, "Only the owner can update this vehicle");
        
        // 更新车辆的年份
        vehicle.year = _year;
    }

    // 删除车辆记录
    function deleteVehicle(uint index) public {
        require(index < vehicles.length, "Invalid vehicle index");
        Vehicle storage vehicle = vehicles[index];
        require(vehicle.owner == msg.sender, "Only the owner can delete this vehicle");

        // 删除车辆记录，使用“数组最后一个元素覆盖当前元素”的方法来减少 gas 消耗
        vehicles[index] = vehicles[vehicles.length - 1];  // 用最后一个元素覆盖要删除的元素
        vehicles.pop();  // 删除最后一个元素
    }

    // 获取所有已注册车辆的数量
    function getVehicleCount() public view returns (uint) {
        return vehicles.length;
    }
}