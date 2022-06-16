import GRDB
import XXModels

extension Contact: FetchableRecord, PersistableRecord {
  enum Column: String, ColumnExpression {
    case id
    case marshaled
    case username
    case email
    case phone
    case nickname
    case photo
    case authStatus
    case isRecent
    case createdAt
  }

  public static let databaseTableName = "contacts"

  public static func request(_ query: Query) -> QueryInterfaceRequest<Contact> {
    var request = Contact.all()

    if let id = query.id {
      if id.count == 1, let id = id.first {
        request = request.filter(id: id)
      } else {
        request = request.filter(id.contains(Column.id))
      }
    }

    if let authStatus = query.authStatus {
      request = request.filter(Set(authStatus.map(\.rawValue)).contains(Column.authStatus))
    }

    switch query.sortBy {
    case .username(desc: false):
      request = request.order(Column.username)

    case .username(desc: true):
      request = request.order(Column.username.desc)

    case .createdAt(desc: false):
      request = request.order(Column.createdAt)

    case .createdAt(desc: true):
      request = request.order(Column.createdAt.desc)
    }

    return request
  }
}
