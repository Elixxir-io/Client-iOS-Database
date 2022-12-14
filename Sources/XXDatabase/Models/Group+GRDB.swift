import GRDB
import XXModels

extension Group: PersistableRecord, FetchableRecord {
  enum Column: String, ColumnExpression {
    case id
    case name
    case leaderId
    case createdAt
    case authStatus
    case serialized
  }

  enum Association {
    static let leader = belongsTo(
      Contact.self,
      using: .init([Column.leaderId], to: [Contact.Column.id])
    )

    static let groupMembers = hasMany(
      GroupMember.self,
      using: .init([GroupMember.Column.groupId], to: [Column.id])
    )

    static let members = hasMany(
      Contact.self,
      through: groupMembers,
      using: GroupMember.Association.contact
    )

    static let messages = hasMany(
      Message.self,
      using: .init([Message.Column.groupId], to: [Column.id])
    )
  }

  public static let databaseTableName = "groups"

  static func request(_ query: Query) -> QueryInterfaceRequest<Group> {
    var request = Group.all()

    if let id = query.id {
      if id.count == 1, let id = id.first {
        request = request.filter(id: id)
      } else {
        request  = request.filter(ids: id)
      }
    }

    if let withMessages = query.withMessages {
      let messageAlias = TableAlias()
      request = request
        .joining(optional: Association.messages.aliased(messageAlias))
        .filter(withMessages ? messageAlias.exists : !messageAlias.exists)
    }

    if let authStatus = query.authStatus {
      request = request.filter(authStatus.map(\.rawValue).contains(Column.authStatus))
    }

    if query.isLeaderBlocked != nil || query.isLeaderBanned != nil {
      let leader = TableAlias(name: "leader")
      request = request.joining(required: Association.leader.aliased(leader))

      if let isLeaderBlocked = query.isLeaderBlocked {
        request = request.filter(leader[Contact.Column.isBlocked] == isLeaderBlocked)
      }

      if let isLeaderBanned = query.isLeaderBanned {
        request = request.filter(leader[Contact.Column.isBanned] == isLeaderBanned)
      }
    }

    switch query.sortBy {
    case .createdAt(desc: false):
      request = request.order(Column.createdAt)

    case .createdAt(desc: true):
      request = request.order(Column.createdAt.desc)
    }

    return request
  }
}
