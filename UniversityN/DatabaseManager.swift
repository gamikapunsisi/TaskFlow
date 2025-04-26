import Foundation
import SQLite3

public class DatabaseManager {
    public static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("universityn.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        // Create tables if they don't exist
        createTables()
    }
    
    private func createTables() {
        // Users table
        let createUsersTable = """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                role TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            );
        """
        
        // Tasks table
        let createTasksTable = """
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                budget INTEGER NOT NULL,
                category TEXT NOT NULL,
                deadline DATETIME NOT NULL,
                status TEXT DEFAULT 'open',
                user_id INTEGER NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id)
            );
        """
        
        // Proposals table
        let createProposalsTable = """
            CREATE TABLE IF NOT EXISTS proposals (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                task_id INTEGER NOT NULL,
                user_id INTEGER NOT NULL,
                amount INTEGER NOT NULL,
                message TEXT,
                status TEXT DEFAULT 'pending',
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (task_id) REFERENCES tasks (id),
                FOREIGN KEY (user_id) REFERENCES users (id)
            );
        """
        
        executeQuery(createUsersTable)
        executeQuery(createTasksTable)
        executeQuery(createProposalsTable)
    }
    
    private func executeQuery(_ query: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error executing query: \(query)")
            }
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - User Operations
    func createUser(name: String, email: String, password: String, role: String) throws -> Int {
        let query = """
            INSERT INTO users (name, email, password, role)
            VALUES (?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        var userId: Int = 0
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (role as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                userId = Int(sqlite3_last_insert_rowid(db))
            } else {
                throw DatabaseError.insertFailed
            }
        }
        
        sqlite3_finalize(statement)
        return userId
    }
    
    func getUser(email: String, password: String) throws -> User? {
        let query = "SELECT * FROM users WHERE email = ? AND password = ?;"
        var statement: OpaquePointer?
        var user: User?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let email = String(cString: sqlite3_column_text(statement, 2))
                let role = String(cString: sqlite3_column_text(statement, 4))
                let createdAt = String(cString: sqlite3_column_text(statement, 5))
                let updatedAt = String(cString: sqlite3_column_text(statement, 6))
                
                user = User(
                    id: id,
                    name: name,
                    email: email,
                    email_verified_at: nil,
                    created_at: createdAt,
                    updated_at: updatedAt,
                    role: role
                )
            }
        }
        
        sqlite3_finalize(statement)
        return user
    }
    
    // MARK: - Task Operations
    func createTask(title: String, description: String, budget: Int, category: String, deadline: String, userId: Int) throws {
        let query = """
            INSERT INTO tasks (title, description, budget, category, deadline, user_id)
            VALUES (?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(budget))
            sqlite3_bind_text(statement, 4, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (deadline as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, Int32(userId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.insertFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func getTasks() throws -> [Task] {
        let query = "SELECT * FROM tasks ORDER BY created_at DESC;"
        var statement: OpaquePointer?
        var tasks: [Task] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let description = String(cString: sqlite3_column_text(statement, 2))
                let budget = Int(sqlite3_column_int(statement, 3))
                let category = String(cString: sqlite3_column_text(statement, 4))
                let deadline = String(cString: sqlite3_column_text(statement, 5))
                let status = String(cString: sqlite3_column_text(statement, 6))
                let userId = Int(sqlite3_column_int(statement, 7))
                let createdAt = String(cString: sqlite3_column_text(statement, 8))
                let updatedAt = String(cString: sqlite3_column_text(statement, 9))
                
                let task = Task(
                    id: id,
                    title: title,
                    description: description,
                    budget: budget,
                    category: category,
                    deadline: deadline,
                    status: status,
                    userId: userId,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
                
                tasks.append(task)
            }
        }
        
        sqlite3_finalize(statement)
        return tasks
    }
    
    func updateTaskStatus(taskId: Int, status: String) throws {
        let query = "UPDATE tasks SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (status as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(taskId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.updateFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteTask(taskId: Int) throws {
        let query = "DELETE FROM tasks WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(taskId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.deleteFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    // MARK: - Proposal Operations
    func createProposal(taskId: Int, userId: Int, amount: Int, message: String) throws {
        let query = """
            INSERT INTO proposals (task_id, user_id, amount, message)
            VALUES (?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(taskId))
            sqlite3_bind_int(statement, 2, Int32(userId))
            sqlite3_bind_int(statement, 3, Int32(amount))
            sqlite3_bind_text(statement, 4, (message as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.insertFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func getProposals(taskId: Int) throws -> [Proposal] {
        let query = """
            SELECT p.*, u.name as user_name
            FROM proposals p
            JOIN users u ON p.user_id = u.id
            WHERE p.task_id = ?
            ORDER BY p.created_at DESC;
        """
        
        var statement: OpaquePointer?
        var proposals: [Proposal] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(taskId))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let taskId = Int(sqlite3_column_int(statement, 1))
                let userId = Int(sqlite3_column_int(statement, 2))
                let amount = Int(sqlite3_column_int(statement, 3))
                let message = String(cString: sqlite3_column_text(statement, 4))
                let status = String(cString: sqlite3_column_text(statement, 5))
                let createdAt = String(cString: sqlite3_column_text(statement, 6))
                let updatedAt = String(cString: sqlite3_column_text(statement, 7))
                let userName = String(cString: sqlite3_column_text(statement, 8))
                
                let proposal = Proposal(
                    id: id,
                    taskId: taskId,
                    userId: userId,
                    amount: amount,
                    message: message,
                    status: status,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                    userName: userName
                )
                
                proposals.append(proposal)
            }
        }
        
        sqlite3_finalize(statement)
        return proposals
    }
    
    func acceptProposal(proposalId: Int) throws {
        let query = "UPDATE proposals SET status = 'accepted', updated_at = CURRENT_TIMESTAMP WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(proposalId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.updateFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func rejectProposal(proposalId: Int) throws {
        let query = "UPDATE proposals SET status = 'rejected', updated_at = CURRENT_TIMESTAMP WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(proposalId))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.updateFailed
            }
        }
        
        sqlite3_finalize(statement)
    }
}

// MARK: - Models
struct Proposal: Identifiable, Codable {
    let id: Int
    let taskId: Int
    let userId: Int
    let amount: Int
    let message: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case taskId = "task_id"
        case userId = "user_id"
        case amount
        case message
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userName = "user_name"
    }
}

// MARK: - Errors
enum DatabaseError: Error {
    case insertFailed
    case updateFailed
    case deleteFailed
    case queryFailed
} 