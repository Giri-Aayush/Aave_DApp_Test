// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract StakeConcept {
    
    address payable clampContractAccount;
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable INSTANCE;

    address private immutable DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F; //polyon mumbai DAI
    IERC20 private DAI;

    constructor(address _address_Provider) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_address_Provider);
        INSTANCE = IPool(ADDRESSES_PROVIDER.getPool());
        clampContractAccount = payable(msg.sender);
        DAI = IERC20(DAIAddress);
    }

    function supplyLiquidity(address _tokenAddress, uint256 _amount) external {
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address onBehalfOf = address(this);
        uint16 referralCode = 0;

        INSTANCE.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdrawlLiquidity(address _tokenAddress, uint256 _amount)
        external
        returns (uint256)
    {
        address asset = _tokenAddress;
        uint256 amount = _amount;
        address to = address(this);

        return INSTANCE.withdraw(asset, amount, to);
    }

    function getUserAccountData(address _userAddress)
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        return INSTANCE.getUserAccountData(_userAddress);
    }

    function approveLINK(uint256 _amount, address _poolContractAddress)
        external
        returns (bool)
    {
        return DAI.approve(_poolContractAddress, _amount);
    }

    function allowanceLINK(address _poolContractAddress)
        external
        view
        returns (uint256)
    {
        return DAI.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == clampContractAccount,
            "Only the contract clampContractAccount can call this function"
        );
        _;
    }

    receive() external payable {}
}
