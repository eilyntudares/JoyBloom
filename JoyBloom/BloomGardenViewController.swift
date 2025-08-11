import UIKit

class BloomGardenViewController: UIViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let flowerContainer = UIView()

    // MARK: - Layout config
    private let columns = 3
    private let itemSize: CGFloat = 90
    private let itemSpacing: CGFloat = 16
    private let gridTopPadding: CGFloat = 240

    private var contentHeightConstraint: NSLayoutConstraint?

    // MARK: - Data
    private var entries: [String] = []
    private var lastCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Garden"
        view.backgroundColor = .systemBackground
        setupScroll()
        setupContainer()
        setupObserver()
        reloadGarden()
        tabBarItem = UITabBarItem(title: "Garden",
                                  image: UIImage(systemName: "leaf"),
                                  selectedImage: UIImage(systemName: "leaf.fill"))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFlowers(animateNew: false)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Setup
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentHeightConstraint?.isActive = true
    }

    private func setupContainer() {
        flowerContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flowerContainer)

        NSLayoutConstraint.activate([
            flowerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: gridTopPadding),
            flowerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            flowerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            flowerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadGardenAndAnimateIfNew),
                                               name: .gratitudeUpdated,
                                               object: nil)
    }

    // MARK: - Data reload
    @objc private func reloadGarden() {
        entries = UserDefaults.standard.stringArray(forKey: "gratitudeEntries") ?? []
        layoutFlowers(animateNew: false)
        lastCount = entries.count
    }

    @objc private func reloadGardenAndAnimateIfNew() {
        let old = lastCount
        entries = UserDefaults.standard.stringArray(forKey: "gratitudeEntries") ?? []
        layoutFlowers(animateNew: entries.count > old)
        lastCount = entries.count
    }

    // MARK: - Layout flowers
    private func layoutFlowers(animateNew: Bool) {
        flowerContainer.subviews.forEach { $0.removeFromSuperview() }

        let total = entries.count
        guard total > 0 else {
            showEmptyState()
            contentHeightConstraint?.constant = gridTopPadding + 160
            return
        }

        let width = view.bounds.width
        let totalSpacing = CGFloat(columns + 1) * itemSpacing
        let usableWidth = width - totalSpacing
        let size = min(itemSize, usableWidth / CGFloat(columns))

        var x: CGFloat = itemSpacing
        var y: CGFloat = 0
        var col = 0

        for i in 0..<total {
            let label = UILabel()
            label.text = "🌸"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: size * 0.7)
            label.frame = CGRect(x: x, y: y, width: size, height: size)
            label.layer.cornerRadius = size / 2
            label.layer.masksToBounds = true
            label.backgroundColor = UIColor.systemPink.withAlphaComponent(0.12)

            let angle = CGFloat.random(in: -0.1...0.1)
            label.transform = CGAffineTransform(rotationAngle: angle)

            if animateNew && i == total - 1 {
                label.alpha = 0
                label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).rotated(by: angle)
                UIView.animate(withDuration: 0.35,
                               delay: 0.0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5,
                               options: [.curveEaseOut]) {
                    label.alpha = 1
                    label.transform = CGAffineTransform.identity.rotated(by: angle)
                }
            }

            flowerContainer.addSubview(label)

            col += 1
            if col == columns {
                col = 0
                x = itemSpacing
                y += size + itemSpacing
            } else {
                x += size + itemSpacing
            }
        }

        let containerHeight = y + size + itemSpacing
        contentHeightConstraint?.constant = max(gridTopPadding + containerHeight, 1)
    }

    private func showEmptyState() {
        let msg = UILabel()
        msg.text = "Your garden is waiting.\nWrite something you’re grateful for to bloom a flower!"
        msg.numberOfLines = 0
        msg.textAlignment = .center
        msg.font = UIFont.preferredFont(forTextStyle: .body)
        msg.translatesAutoresizingMaskIntoConstraints = false
        flowerContainer.addSubview(msg)

        NSLayoutConstraint.activate([
            msg.topAnchor.constraint(equalTo: flowerContainer.topAnchor, constant: 40),
            msg.leadingAnchor.constraint(equalTo: flowerContainer.leadingAnchor, constant: 24),
            msg.trailingAnchor.constraint(equalTo: flowerContainer.trailingAnchor, constant: -24),
            msg.bottomAnchor.constraint(equalTo: flowerContainer.bottomAnchor, constant: -40)
        ])
    }
}

