
struct Follower: Codable, Hashable {
    var id: String { return login }
    let login: String
    let avatarUrl: String
}
