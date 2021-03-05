//
//  main.swift
//  EnumMetadata
//
//  Created by HarryPhone on 2021/3/5.
//

import Foundation

enum Animal {
    case bird(String, Int, Double)
    case cat
    case dog
    case tiger
    case rabbit(String, Int)
    
}


// 通过源码我们可以知道Type类型对应的就是Metadata，这里记住要转成Any.Type，不然typesize不一致，不让转
let ptr = unsafeBitCast(Animal.self as Any.Type, to: UnsafeMutablePointer<EnumMetadata>.self)

// 类型见：https://juejin.cn/post/6919034854159941645
// 0x201是枚举 0x202是可选类型
let kind = ptr.pointee.Kind
print("kind: \(String(kind, radix: 16))")

// 枚举描述指针
let descriptionptr = ptr.pointee.Description

// 公共标记中获取kind
let flags = descriptionptr.pointee.Flags
print("FlagKind: \(flags.getContextDescriptorKind()!)")

let name = descriptionptr.pointee.Name.get()
print("名称: \(String(cString: name))")

let count = Int(descriptionptr.pointee.getNumCases())
print("枚举个数: \(count)")

print("---------")
(0..<count).forEach {
    let propertyPtr = descriptionptr.pointee.Fields.get().pointee.getField(index: $0)
    print("""
        属性名：\(String(cString: propertyPtr.pointee.FieldName.get()))
        类型命名重整：\(String(cString: propertyPtr.pointee.MangledTypeName.get()))
        ---------
        """)
}


print(ptr.pointee)
print(ptr.pointee.Description.pointee)

print("end")
