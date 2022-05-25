import Combine

public struct GroupChatInfo: Identifiable, Equatable, Codable {
  public typealias ID = Group.ID

  public init(
    group: Group,
    lastMessage: Message,
    unreadCount: Int
  ) {
    self.group = group
    self.lastMessage = lastMessage
    self.unreadCount = unreadCount
  }

  public var id: ID { group.id }
  public var group: Group
  public var lastMessage: Message
  public var unreadCount: Int
}

extension GroupChatInfo {
  public typealias Fetch = XXModels.Fetch<GroupChatInfo, Query>
  public typealias FetchPublisher = XXModels.FetchPublisher<GroupChatInfo, Query>

  public struct Query: Equatable {
    public init() {}
  }
}