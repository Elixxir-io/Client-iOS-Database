import CustomDump
import XCTest
import XXModels
@testable import XXDatabase

final class GroupMemberTests: XCTestCase {
  var db: Database!

  override func setUp() async throws {
    db = try Database.inMemory()
  }

  override func tearDown() async throws {
    db = nil
  }

  func testDatabaseOperations() throws {
    let save: GroupMember.Save = db.save(_:)
    let delete: GroupMember.Delete = db.delete(_:)

    func fetchAll() throws -> [GroupMember] {
      try db.fetch(GroupMember.all())
    }

    let contactA = Contact.stub(1)
    let contactB = Contact.stub(2)
    let contactC = Contact.stub(3)
    let groupA = Group.stub(1, leaderId: contactA.id)
    let groupB = Group.stub(2, leaderId: contactB.id)

    _ = try db.save(contactA)
    _ = try db.save(contactB)
    _ = try db.save(contactC)
    _ = try db.save(groupA)
    _ = try db.save(groupB)

    // Add contacts A and B as members of group A:

    _ = try save(GroupMember(groupId: groupA.id, contactId: contactA.id))
    _ = try save(GroupMember(groupId: groupA.id, contactId: contactB.id))

    XCTAssertNoDifference(try fetchAll(), [
      GroupMember(groupId: groupA.id, contactId: contactA.id),
      GroupMember(groupId: groupA.id, contactId: contactB.id),
    ])

    // Add contacts B and C as members of group B:

    _ = try save(GroupMember(groupId: groupB.id, contactId: contactB.id))
    _ = try save(GroupMember(groupId: groupB.id, contactId: contactC.id))

    XCTAssertNoDifference(try fetchAll(), [
      GroupMember(groupId: groupA.id, contactId: contactA.id),
      GroupMember(groupId: groupA.id, contactId: contactB.id),
      GroupMember(groupId: groupB.id, contactId: contactB.id),
      GroupMember(groupId: groupB.id, contactId: contactC.id),
    ])

    // Delete contact C from group B:

    _ = try delete(GroupMember(groupId: groupB.id, contactId: contactC.id))

    XCTAssertNoDifference(try fetchAll(), [
      GroupMember(groupId: groupA.id, contactId: contactA.id),
      GroupMember(groupId: groupA.id, contactId: contactB.id),
      GroupMember(groupId: groupB.id, contactId: contactB.id),
    ])

    // Delete contact B (belonging to groups A and B):

    _ = try db.delete(contactB)

    XCTAssertNoDifference(try fetchAll(), [
      GroupMember(groupId: groupA.id, contactId: contactA.id),
    ])

    // Delete group B:

    _ = try db.delete(groupB)

    XCTAssertNoDifference(try fetchAll(), [
      GroupMember(groupId: groupA.id, contactId: contactA.id),
    ])

    // Delete group A:

    _ = try db.delete(groupA)

    XCTAssertNoDifference(try fetchAll(), [])
  }
}