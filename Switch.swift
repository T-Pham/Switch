//
//  Switch.swift
//
//  Created by Thanh Pham on 8/24/16.
//

import UIKit

@IBDesignable public class Switch: UIControl {

    let backgroundLayer = RoundLayer()
    let switchLayer = RoundLayer()

    var previousPoint: CGPoint?
    var switchLayerLeftPosition: CGPoint?
    var switchLayerRightPosition: CGPoint?

    static let labelFactory: () -> UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        return label
    }

    public let leftLabel = labelFactory()
    public let rightLabel = labelFactory()

    @IBInspectable public var leftText: String? {
        get {
            return leftLabel.text
        }
        set {
            leftLabel.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable public var rightText: String? {
        get {
            return rightLabel.text
        }
        set {
            rightLabel.text = newValue
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable public var rightSelected: Bool = false {
        didSet {
            reloadSwitchLayerPosition()
            reloadLabelsTextColor()
            sendActionsForControlEvents(.ValueChanged)
        }
    }

    @IBInspectable public var disabledColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            backgroundLayer.borderColor = disabledColor.CGColor
            reloadLabelsTextColor()
        }
    }

    override public var tintColor: UIColor! {
        didSet {
            switchLayer.borderColor = tintColor.CGColor
            reloadLabelsTextColor()
        }
    }

    var touchBegan = false
    var touchBeganInSwitchLayer = false
    var touchMoved = false

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        backgroundLayer.backgroundColor = UIColor.whiteColor().CGColor
        backgroundLayer.borderColor = disabledColor.CGColor
        backgroundLayer.borderWidth = 1
        layer.addSublayer(backgroundLayer)

        switchLayer.borderColor = tintColor.CGColor
        switchLayer.borderWidth = 1
        layer.addSublayer(switchLayer)

        addSubview(leftLabel)
        addSubview(rightLabel)
        reloadLabelsTextColor()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        leftLabel.frame = CGRectMake(0, 0, bounds.size.width / 2, bounds.size.height)
        rightLabel.frame = CGRectMake(bounds.size.width / 2, 0, bounds.size.width / 2, bounds.size.height)
    }

    override public func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        guard layer == self.layer else {
            return
        }
        backgroundLayer.frame = layer.bounds
        switchLayer.bounds = CGRectMake(0, 0, layer.bounds.size.width / 2, layer.bounds.size.height)
        switchLayerLeftPosition = CGPointApplyAffineTransform(layer.convertPoint(layer.position, fromLayer: layer.superlayer), CGAffineTransformMakeTranslation(-switchLayer.bounds.size.width / 2, 0))
        switchLayerRightPosition = CGPointApplyAffineTransform(switchLayerLeftPosition!, CGAffineTransformMakeTranslation(switchLayer.bounds.size.width, 0))
        touchBegan = false
        touchBeganInSwitchLayer = false
        touchMoved = false
        previousPoint = nil
        reloadSwitchLayerPosition()
    }

    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        touchBegan = true
        previousPoint = touches.first!.locationInView(self)
        touchBeganInSwitchLayer = switchLayer.containsPoint(switchLayer.convertPoint(previousPoint!, fromLayer: layer))
    }

    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        touchMoved = true
        guard touchBeganInSwitchLayer else {
            return
        }
        let point = touches.first!.locationInView(self)
        var position = CGPointApplyAffineTransform(switchLayer.position, CGAffineTransformMakeTranslation(point.x - previousPoint!.x, 0))
        position.x = max(switchLayer.bounds.size.width / 2, min(layer.bounds.size.width - switchLayer.bounds.size.width / 2, position.x))
        switchLayer.position = position
        previousPoint = point
    }

    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
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

    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        previousPoint = nil
        reloadSwitchLayerPosition()
        touchBegan = false
        touchBeganInSwitchLayer = false
        touchMoved = false
    }

    override public func sizeThatFits(size: CGSize) -> CGSize {
        let labelSize = CGSizeMake((size.width - 3 * size.height / 2) / 2, size.height)
        return desiredSizeForLeftSize(leftLabel.sizeThatFits(labelSize), rightSize: rightLabel.sizeThatFits(labelSize))
    }

    override public func intrinsicContentSize() -> CGSize {
        return desiredSizeForLeftSize(leftLabel.intrinsicContentSize(), rightSize: rightLabel.intrinsicContentSize())
    }

    func desiredSizeForLeftSize(leftSize: CGSize, rightSize: CGSize) -> CGSize {
        let height = max(leftSize.height, rightSize.height)
        return CGSizeMake(max(leftSize.width, rightSize.width) * 2 + 3 * height / 2, height)
    }

    func reloadLabelsTextColor() {
        leftLabel.textColor = rightSelected ? disabledColor : tintColor
        rightLabel.textColor = rightSelected ? tintColor : disabledColor
    }

    func reloadSwitchLayerPosition() {
        guard let switchLayerLeftPosition = switchLayerLeftPosition, switchLayerRightPosition = switchLayerRightPosition else {
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
