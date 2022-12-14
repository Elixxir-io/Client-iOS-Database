import XCTest
@testable import XXModels

final class GroupChatInfoTests: XCTestCase {
  func testId() {
    let leader = Contact(
      id: "leader-contact-id".data(using: .utf8)!
    )

    let group = Group(
      id: "group-id".data(using: .utf8)!,
      name: "group-name",
      leaderId: leader.id,
      createdAt: Date(timeIntervalSince1970: 1234),
      authStatus: .pending,
      serialized: "group-serialized".data(using: .utf8)!
    )

    let message = Message(
      senderId: "sender-id".data(using: .utf8)!,
      recipientId: nil,
      groupId: nil,
      date: Date(timeIntervalSince1970: 1234),
      status: .received,
      isUnread: true,
      text: "text"
    )

    let chatInfo = GroupChatInfo(
      group: group,
      lastMessage: message,
      unreadCount: 1234
    )

    XCTAssertEqual(chatInfo.id, group.id)
  }
}
