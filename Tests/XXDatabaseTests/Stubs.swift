import Foundation
import XXModels

extension Date {
  static func stub(_ ti: TimeInterval) -> Date {
    Date(timeIntervalSince1970: ti)
  }
}

extension Contact {
  static func stub(
    _ id: String,
    authStatus: AuthStatus = .stranger
  ) -> Contact {
    Contact(
      id: "contact-id-\(id)".data(using: .utf8)!,
      marshaled: "contact-marshaled-\(id)".data(using: .utf8)!,
      username: "contact-username-\(id)",
      email: "contact-\(id)@elixxir.io",
      phone: "contact-phone-\(id)",
      nickname: "contact-nickname-\(id)",
      authStatus: authStatus,
      createdAt: .stub(0)
    )
  }
}

extension Group {
  static func stub(
    _ id: String,
    leaderId: Data,
    createdAt: Date,
    authStatus: AuthStatus = .pending
  ) -> Group {
    Group(
      id: "group-id-\(id)".data(using: .utf8)!,
      name: "group-name-\(id)",
      leaderId: leaderId,
      createdAt: createdAt,
      authStatus: authStatus,
      serialized: "group-serialized-\(id)".data(using: .utf8)!
    )
  }
}

extension Message {
  static func stub(
    from sender: Contact,
    to recipient: Contact,
    at timeInterval: TimeInterval,
    networkId: Data? = nil,
    status: Status = .received,
    isUnread: Bool = false
  ) -> Message {
    Message(
      networkId: networkId,
      senderId: sender.id,
      recipientId: recipient.id,
      groupId: nil,
      date: .stub(timeInterval),
      status: status,
      isUnread: isUnread,
      text: "\(sender.username ?? "?") → \(recipient.username ?? "?") @ \(timeInterval)"
    )
  }

  static func stub(
    from sender: Contact,
    to group: Group,
    at timeInterval: TimeInterval,
    networkId: Data? = nil,
    status: Status = .received,
    isUnread: Bool = false
  ) -> Message {
    Message(
      networkId: networkId,
      senderId: sender.id,
      recipientId: nil,
      groupId: group.id,
      date: .stub(timeInterval),
      status: status,
      isUnread: isUnread,
      text: "\(sender.username ?? "?") → G:\(group.name) @ \(timeInterval)"
    )
  }
}
