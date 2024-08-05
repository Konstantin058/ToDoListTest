//
//  HomeTableViewCell.swift
//  ToDoListTest
//
//  Created by Константин Евсюков on 03.08.2024.
//

import UIKit
import SnapKit

protocol HomeTableViewCellDelegate: AnyObject {
    func didTapCheckButton(on cell: HomeTableViewCell)
}

class HomeTableViewCell:  UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    private let container = UIView()
    private let titleLabel = UILabel()
    private let checkButton = UIButton()
    
    weak var delegate: HomeTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(list: ListModel) {
        titleLabel.text = list.title
    }
}

//MARK: Setup UI
private extension HomeTableViewCell {
    
    func setupUI() {
        setupContainerView()
        setupLabel()
        setupButton()
        addSubViews()
        makeConstraints()
    }
    
    func setupContainerView() {
        container.backgroundColor = .white.withAlphaComponent(0.8)
        container.clipsToBounds = false
        container.layer.cornerRadius = 15
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
    }
    
    func setupButton() {
        checkButton.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        checkButton.tintColor = .black
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    func addSubViews() {
        contentView.addSubview(container)
        
        [titleLabel, checkButton].forEach {
            container.addSubview($0)
        }
    }
    
    func makeConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(20)
        }
    }
    
    @objc func checkButtonTapped() {
        delegate?.didTapCheckButton(on: self)
    }
}
