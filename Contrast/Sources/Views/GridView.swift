import AppKit

final class GridView: NSView {

	// MARK: - Properties

	let rows: Int
	let columns: Int
	let dimension: CGFloat

	// MARK: - Initializers

	/// It's recommended that the rows and columns are even
	init(rows: Int, columns: Int, dimension: CGFloat) {
		self.rows = rows
		self.columns = columns
		self.dimension = dimension

		super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(columns) * dimension, height: CGFloat(rows) * dimension))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView

	override func draw(_ dirtyRect: NSRect) {
		guard let context = NSGraphicsContext.current?.cgContext else {
			return
		}

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let color = CGColor(colorSpace: colorSpace, components: [0, 0, 0, 0.2])!
		context.setStrokeColor(color)

		let lineWidth: CGFloat = 1
		context.setLineWidth(lineWidth)

		// Stroke the border
		context.stroke(bounds)

		for x in 1..<rows {
			// Vertical line
			context.move(to: CGPoint(x: CGFloat(x) * dimension, y: 0))
			context.addLine(to: CGPoint(x: CGFloat(x) * dimension, y: bounds.height))

			for y in 1..<columns {
				// Horizontal line
				context.move(to: CGPoint(x: 0, y: CGFloat(y) * dimension))
				context.addLine(to: CGPoint(x: bounds.width, y: CGFloat(y) * dimension))
			}
		}

		// Stroke grid
		context.strokePath()

		// Stroke center square
		context.setStrokeColor(CGColor(colorSpace: colorSpace, components: [0, 0, 0, 1])!)
		let center = CGRect(x: CGFloat(columns / 2) * dimension, y: CGFloat(rows / 2) * dimension, width: dimension,
							height: dimension)
		context.stroke(center)

		context.setStrokeColor(CGColor(colorSpace: colorSpace, components: [1, 1, 1, 1])!)
		context.stroke(center.insetBy(dx: -lineWidth, dy: -lineWidth))
	}
}
