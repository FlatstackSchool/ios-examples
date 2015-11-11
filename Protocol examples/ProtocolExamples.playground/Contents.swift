//: Playground - noun: a place where people can play

import Foundation

/* 
Используется typalias'ы для простых типов типа точки на плоскости, чтобы не использовать системные структуры типа CGPoint, CGSize и прочее, а использовать простые типы
Также поддержка протокола Equatable для этих alias'ов
*/

typealias Point     = (x: Double, y: Double)
typealias Size      = (width: Double, height: Double)

typealias Point3D   = (x: Double, y: Double, z: Double)
typealias Volume    = (width: Double, lenght: Double, height: Double)

func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && rhs.y == rhs.y
}

func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && rhs.height == rhs.height
}

func == (lhs: Point3D, rhs: Point3D) -> Bool {
    return lhs.x == rhs.x && rhs.y == rhs.y && rhs.z == rhs.z
}

func == (lhs: Volume, rhs: Volume) -> Bool {
    return lhs.width == rhs.width && rhs.lenght == rhs.lenght && rhs.height == rhs.height
}

//============================================

//Протокол Shape - двумерная фигура на плоскости
protocol Shape {
    /// Центр фигуры
    var shapeCenter: Point  {get set}
    /// Размер фигуры
    var shapeSize: Size     {get set}
    
    /// Стандартный инициализатор, который требуется для стандартной имплементации `init (center: Point, size: Size)` в расширении протокла
    init ()
    /// Необходимо поддерживать инициализацию с заданием центра и размера
    init (center: Point, size: Size)
    
    /// Сравнение двух Shape'ов
    func isEqualTo (other: Shape) -> Bool
}

// Это расширение протокола добавляет стандартную имплементацию приведенных ниже методов для ВСЕХ структур или объектов, поддерживающих этот протокол
extension Shape {
    init (center: Point, size: Size) {
        /*
        При описании стандартной имплементации НЕОБХОДИМО вызвать инициализатор, для которого стандартная имплементация в расширениях протокола ОТСУТСТВУЕТ
        Это необходимо потому, что для каждой структуры или объекта необходимо инициализировать их собственные поля в этих инициализаторах, которые не имеют дэфолтных значений, и без определения которых невозможно инициализировать структуру или объект
        */
        self.init()
        self.shapeCenter = center
        self.shapeSize = size
    }
    
    func isEqualTo (other: Shape) -> Bool {
        // `Self` - обозначает класс или тип текущего объекта или структуры
        guard let object = other as? Self else {return false}
        return self.shapeCenter == object.shapeCenter &&
            self.shapeSize == object.shapeSize
    }
}

/// Поддержка протокола Equatable для структур и объектов, поддерживающих протокол Shape
func == (lhs: Shape, rhs: Shape) -> Bool {
    return lhs.isEqualTo(rhs)
}

//-----------------------------------------------

// Протокол для фигур в трехмерном пространстве
protocol Shape3D {
    var shape3DCenter: Point3D  {get set}
    var shape3DVolume: Volume   {get set}
    
    init ()
    init (center: Point3D, volume: Volume)
    
    func isEqualTo (other: Shape3D) -> Bool
}

extension Shape3D {
    init (center: Point3D, volume: Volume) {
        self.init()
        self.shape3DCenter = center
        self.shape3DVolume = volume
    }
    
    func isEqualTo (other: Shape3D) -> Bool {
        guard let object = other as? Self else {return false}
        return self.shape3DCenter == object.shape3DCenter && self.shape3DVolume == object.shape3DVolume
    }
}

func == (lhs: Shape3D, rhs: Shape3D) -> Bool {
    return lhs.isEqualTo(rhs)
}

//-----------------------------------------------

// Протокол, который добавляет поддержку передвижения фигур
protocol Moveble {
    mutating func moveByX (offset: Double)
    mutating func moveByY (offset: Double)
}

// Это расширение для протокола Moveble, которое добавляет стандартную имплементацию протокола, если текущая структура или объект ПОДДЕРЖИВАЕТ ПРОТОКОЛ `Shape`
extension Moveble where Self: Shape {
    // Здесь мы добавляем дополнительный метод для конкретного расширения протокола (только если текущая структура или объект поддерживает протокол Shape)
    mutating func move (offset: Point) {
        self.moveByX(offset.x)
        self.moveByY(offset.y)
    }
    
    mutating func moveByX (offset: Double) {
        self.shapeCenter.x += offset
    }
    
    mutating func moveByY (offset: Double) {
        self.shapeCenter.y += offset
    }
}

extension Moveble where Self: Shape3D {
    mutating func move (offset: Point3D) {
        self.moveByX(offset.x)
        self.moveByY(offset.y)
        self.moveByZ(offset.z)
    }
    
    mutating func moveByX (offset: Double) {
        self.shape3DCenter.x += offset
    }
    
    mutating func moveByY (offset: Double) {
        self.shape3DCenter.y += offset
    }
    
    mutating func moveByZ (offset: Double) {
        self.shape3DCenter.y += offset
    }
}

//-----------------------------------------------

protocol Transformable {
    mutating func transformSize (x: Double, y: Double, z: Double)
}

extension Transformable where Self: Shape {
    mutating func transformSize (x: Double, y: Double, z: Double) {
        self.shapeSize.width = self.shapeSize.width * x
        self.shapeSize.height = self.shapeSize.height * y
    }
}

extension Transformable where Self: Shape3D {
    mutating func transformSize (x: Double, y: Double, z: Double) {
        self.shape3DVolume.width = self.shape3DVolume.width * x
        self.shape3DVolume.lenght = self.shape3DVolume.lenght * y
        self.shape3DVolume.height = self.shape3DVolume.height * z
    }
}

//==================================================

struct Rectangle: Shape, Moveble, Transformable {
    var shapeCenter: Point
    var shapeSize: Size
    
    init() {
        self.shapeCenter    = (0, 0)
        self.shapeSize      = (0, 0)
    }
}

struct Oval: Shape, Moveble, Transformable {
    var shapeCenter: Point
    var shapeSize: Size
    
    init() {
        self.shapeCenter    = (0, 0)
        self.shapeSize      = (0, 0)
    }
    
    init (center: Point, radius: Double) {
        self.shapeCenter    = center
        self.shapeSize      = (radius*2, radius*2)
    }
}

//----------------------------------------------------

struct Parallelepiped: Shape3D, Moveble, Transformable {
    var shape3DCenter: Point3D
    var shape3DVolume: Volume
    
    init() {
        self.shape3DCenter = (0, 0, 0)
        self.shape3DVolume = (0, 0, 0)
    }
}

//====================================================









