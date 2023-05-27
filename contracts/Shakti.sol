//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Structure of the note.
struct Note {

    // Encrypted Content CID value from IPFS.
    string encryptedContentCID;

    // Hash of Original Note represents the hash of data before encryption.
    // This will be used verify that the exact same content was made public on IPFS in future
    // so, verification will be, hashOfOriginalNote == hash of unencryptedContentCID's data.
    string hashOfOriginalNote;

    // Unencrypted Content CID value from IPFS.
    string unencryptedContentCID;
}

contract Shakti {
    address private owner;

    event NewNote(Note note, address sender, uint256 index);

    event PublicNote(Note note, address sender, uint256 index);

    mapping(address => Note[]) private addressToPrivateNotes;

    constructor() {
        owner = msg.sender;
    }

    function getNotes() public view returns (Note[] memory) {
        require(
            addressToPrivateNotes[msg.sender].length > 0,
            "User don't have any notes"
        );

        return addressToPrivateNotes[msg.sender];
    }

    function getNote(uint256 index) public view returns (Note memory) {
        require(
            addressToPrivateNotes[msg.sender].length > index,
            "User don't have note at index."
        );

        return addressToPrivateNotes[msg.sender][index];
    }

    function createNote(
        string calldata encryptedContentCID,
        string calldata hashOfOriginalNote
    ) external {
        Note memory newNote = Note(encryptedContentCID, hashOfOriginalNote, "");

        addressToPrivateNotes[msg.sender].push(newNote);

        emit NewNote(
            newNote,
            msg.sender,
            addressToPrivateNotes[msg.sender].length - 1
        );
    }

    function makeNotePublic(
        uint256 index,
        string memory unencryptedContentCID
    ) public {
        require(
            addressToPrivateNotes[msg.sender].length > index,
            "User don't have note at index."
        );

        addressToPrivateNotes[msg.sender][index]
            .unencryptedContentCID = unencryptedContentCID;

        emit PublicNote(
            addressToPrivateNotes[msg.sender][index],
            msg.sender,
            index
        );
    }
}
