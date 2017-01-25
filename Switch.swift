//
//  Switch.swift
//
//  Created by Thanh Pham on 8/24/16.
//

import UIKit

/// A switch control
@IBDesignable open class Switch: UIControl {

    let backgroundLayer = RoundLayer()
    let switchLayer = RoundLayer()

    var previousPoint: CGPoint?
    var switchLayerLeftPosition: CGPoint?
    var switchLayerRightPosition: CGPoint?

    static let labelFactory: () -> UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }

    /// The label on the left. Don't set the `textColor` and `text` properties on this label. Set them on the `leftText`, `tintColor` and `disabledColor` properties of the switch instead.
    open let leftLabel = labelFactory()

    /// The label on the right. Don't set the `textColor` and `text` properties on this label. Set them on the `rightText`, `tintColor` and `disabledColor` properties of the switch instead.
    open let rightLabel = labelFactory()

    /// Text for the label on the left. Setting this property instead of the `text` property of the `leftLabel` to trigger Auto Layout automatically.
    @IBInspectable open var leftText: String? {
        get {
            return leftLabel.text
        }
        set {
            leftLabel.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    /// Text for the label on the right. Setting this property instead of the `text` property of the `rightLabel` to trigger Auto Layout automatically.
    @IBInspectable open var rightText: String? {
        get {
            return rightLabel.text
        }
        set {
            rightLabel.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    /// True when the right value is selected, false when the left value is selected. When this property is changed, the UIControlEvents.ValueChanged is fired.
    @IBInspectable open var rightSelected: Bool = false {
        didSet {
            reloadSwitchLayerPosition()
            reloadLabelsTextColor()
            sendActions(for: .valueChanged)
        }
    }

    /// The color used for the unselected text and the border. The default value is light gray.
    @IBInspectable open var disabledColor: UIColor = UIColor.lightGray {
        didSet {
            backgroundLayer.borderColor = disabledColor.cgColor
            reloadLabelsTextColor()
        }
    }

    /// The color used for the switch background. Transparent by default.
    @IBInspectable open var backColor: UIColor = UIColor.clear {
        didSet {
            backgroundLayer.backgroundColor = backColor.cgColor
        }
    }

    /// The color used for the selected text and the switch border.
    override open var tintColor: UIColor! {
        didSet {
            switchLayer.borderColor = tintColor.cgColor
            reloadLabelsTextColor()
        }
    }

    var touchBegan = false
    var touchBeganInSwitchLayer = false
    var touchMoved = false

    /// Init with coder.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        backgroundLayer.backgroundColor = UIColor.white.cgColor
        backgroundLayer.borderColor = disabledColor.cgColor
        backgroundLayer.borderWidth = 1
        layer.addSublayer(backgroundLayer)

        switchLayer.borderColor = tintColor.cgColor
        switchLayer.borderWidth = 1
        layer.addSublayer(switchLayer)

        addSubview(leftLabel)
        addSubview(rightLabel)
        reloadLabelsTextColor()
    }

    /// Layouts subviews. Should not be called directly.
    override open func layoutSubviews() {
        super.layoutSubviews()
        leftLabel.frame = CGRect(x: 0, y: 0, width: bounds.size.width / 2, height: bounds.size.height)
        rightLabel.frame = CGRect(x: bounds.size.width / 2, y: 0, width: bounds.size.width / 2, height: bounds.size.height)
    }

    /// Layouts sublayers of a layer. Should not be called directly.
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        guard layer == self.layer else {
            return
        }
        backgroundLayer.frame = layer.bounds
        switchLayer.bounds = CGRect(x: 0, y: 0, width: layer.bounds.size.width / 2, height: layer.bounds.size.height)
        switchLayerLeftPosition = layer.convert(layer.position, from: layer.superlayer).applying(CGAffineTransform(translationX: -switchLayer.bounds.size.width / 2, y: 0))
        switchLayerRightPosition = switchLayerLeftPosition!.applying(CGAffineTransform(translationX: switchLayer.bounds.size.width, y: 0))
        touchBegan = false
        touchBeganInSwitchLayer = false
        touchMoved = false
        previousPoint = nil
        reloadSwitchLayerPosition()
    }

    /// Touches began event handler. Should not be called directly.
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBegan = true
        previousPoint = touches.first!.location(in: self)
        touchBeganInSwitchLayer = switchLayer.contains(switchLayer.convert(previousPoint!, from: layer))
    }

    /// Touches moved event handler. Should not be called directly.
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved = true
        guard touchBeganInSwitchLayer else {
            return
        }
        let point = touches.first!.location(in: self)
        var position = switchLayer.position.applying(CGAffineTransform(translationX: point.x - previousPoint!.x, y: 0))
        position.x = max(switchLayer.bounds.size.width / 2, min(layer.bounds.size.width - switchLayer.bounds.size.width / 2, position.x))
        switchLayer.position = position
        previousPoint = point
    }

    /// Touches ended event handler. Should not be called directly.
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard touchBegan else {
            return
        }
        previousPoint = nil
        if touchMoved && touchBeganInSwitchLayer {
            rightSelected = abs(switchLayerLeftPosition!.x - switchLayer.position.x) > abs(switchLayerRightPosition!.x - switchLayer.position.x)
        } else if !touchMoved && !touchBeganInSwitchLayer {
            rightSelected = !rightSelected
        }
        touchBegan = false
        touchBeganInSwitchLayer = false
        touchMoved = false
    }

    /// Touches cancelled event handler. Should not be called directly.
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        previousPoint = nil
        reloadSwitchLayerPosition()
        touchBegan = false
        touchBeganInSwitchLayer = false
        touchMoved = false
    }

    /// Returns the minimum size that fits a given size.
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = CGSize(width: (size.width - 3 * size.height / 2) / 2, height: size.height)
        return desiredSizeForLeftSize(leftLabel.sizeThatFits(labelSize), rightSize: rightLabel.sizeThatFits(labelSize))
    }

    /// The minimum size used for Auto Layout.
    override open var intrinsicContentSize : CGSize {
        return desiredSizeForLeftSize(leftLabel.intrinsicContentSize, rightSize: rightLabel.intrinsicContentSize)
    }

    func desiredSizeForLeftSize(_ leftSize: CGSize, rightSize: CGSize) -> CGSize {
        let height = max(leftSize.height, rightSize.height)
        return CGSize(width: max(leftSize.width, rightSize.width) * 2 + 3 * height / 2, height: height)
    }

    func reloadLabelsTextColor() {
        leftLabel.textColor = rightSelected ? disabledColor : tintColor
        rightLabel.textColor = rightSelected ? tintColor : disabledColor
    }

    func reloadSwitchLayerPosition() {
        guard let switchLayerLeftPosition = switchLayerLeftPosition, let switchLayerRightPosition = switchLayerRightPosition else {
            return
        }
        switchLayer.position = rightSelected ? switchLayerRightPosition : switchLayerLeftPosition
    }
}

class RoundLayer: CALayer {

    override func layoutSublayers() {
        super.layoutSublayers()
        cornerRadius = bounds.size.height / 2
    }
}
