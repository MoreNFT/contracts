contract Creator {
    mapping(uint256 => address) public _creators;

    function _setCreator(uint256 tokenId, address creator) internal virtual {
        _creators[tokenId] = creator;
    }

    function getCreator(uint256 tokenId) public view returns(address) {
        return _creators[tokenId];
    }
}