//
//  AlertManager.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 04.08.2024.
//

import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            vc.present(alert, animated: true)
        }
    }
}

//MARK: SignIn Error
extension AlertManager {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Не удалось войти", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Не удалось войти", message: "Error: \(error.localizedDescription)")
    }
}

//MARK: SignUp Error
extension AlertManager {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Не удалось зарегистрировать пользователя", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Не удалось зарегистрировать пользователя", message: "Error: \(error.localizedDescription)")
    }
}

//MARK: Close Error
extension AlertManager {
    
    public static func showCloseError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Произошла ошибка при выходе", message: "\(error.localizedDescription)")
    }
}

//MARK: Forgot Password
extension AlertManager {
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Отправлен сброс пароля", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Произошла ошибка при сбросе пароля", message: "Ошибка: \(error.localizedDescription)")
    }
}

//MARK: Fetching User Error
extension AlertManager {
    
    public static func showFetchingUseError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка выбора пользователя", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUseError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Ошибка выбора пользователя", message: nil)
    }
}

//MARK: Add Task Error
extension AlertManager {
    
    public static func showAddTaskError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка добавления задачи", message: "\(error.localizedDescription)")
    }
    
    public static func showFetchTaskError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка извлечения задачи", message: "\(error.localizedDescription)")
    }
}

//MARK: Edit Task Error
extension AlertManager {
    public static func showEditTaskError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при изменении задачи", message: "\(error.localizedDescription)")
    }
}

//MARK: Delete Task Error
extension AlertManager {
    
    public static func showDeleteTaskError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Ошибка при удалении задачи", message: "\(error.localizedDescription)")
    }
}
