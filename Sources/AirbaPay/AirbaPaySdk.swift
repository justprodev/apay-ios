//
// Created by Mikhail Belikov on 16.08.2023.
//

import Foundation
import SwiftUI

public class AirbaPaySdk {
    // todo возможно, когда-нибудь можно будет переделать на это
    //   https://anuragajwani.medium.com/how-to-build-universal-ios-frameworks-using-xcframeworks-4c2790cfa623
    //   и можно будет избавиться от боли с тестированием правок
    public init() {}

    public enum Lang: Equatable {
        
        case RU(lang: String = "ru")
        case KZ(lang: String = "kz")
    }

    public struct Goods: Encodable {
        public init(
            brand: String,
            category: String,
            model: String,
            quantity: Int,
            price: Int
        ) {
            self.brand = brand
            self.category = category
            self.model = model
            self.quantity = quantity
            self.price = price
        }

        let brand: String // Брэнд продукта
        let category: String // Категория продукта
        let model: String // Модель продукта
        let quantity: Int // Количество в корзине
        let price: Int // Цена продукта
    }

    public struct SettlementPayment: Encodable {
        let amount: Int
        let companyId: String?

        public init(
            amount: Int,
            companyId: String?
        ) {
            self.amount = amount
            self.companyId = companyId
        }

        enum CodingKeys: String, CodingKey {
            case amount = "amount"
            case companyId = "company_id"
        }
    }

    public static func initOnCreate(
            isProd: Bool,
            lang: Lang,
            phone: String,
            userEmail: String?,
            shopId: String,
            password: String,
            terminalId: String,
            failureCallback: String,
            successCallback: String,
            colorBrandMain: Color? = nil,
            colorBrandInversion: Color? = nil
    ) {

        if (colorBrandInversion != nil) {
            ColorsSdk.colorBrandInversion = colorBrandInversion!
        }

        if (colorBrandMain != nil) {
            ColorsSdk.colorBrandMain = colorBrandMain!
        }

        DataHolder.bankCode = nil
        DataHolder.accessToken = nil
        DataHolder.isProd = isProd

        if (DataHolder.isProd) {
            DataHolder.baseUrl = "https://ps.airbapay.kz/acquiring-api/sdk/"
        } else {
            DataHolder.baseUrl = "https://sps.airbapay.kz/acquiring-api/sdk/"
        }

        DataHolder.userPhone = phone
        DataHolder.userEmail = userEmail

        DataHolder.failureBackUrl = "https://site.kz/failure" // не нужно
        DataHolder.failureCallback = failureCallback
        DataHolder.successBackUrl = "https://site.kz/success"// не нужно
        DataHolder.successCallback = successCallback

        DataHolder.sendTimeout = 60
        DataHolder.connectTimeout = 60
        DataHolder.receiveTimeout = 60
        DataHolder.shopId = shopId
        DataHolder.password = password
        DataHolder.terminalId = terminalId

        DataHolder.currentLang = lang

    }

    public static func initProcessing(
            purchaseAmount: Int,
            invoiceId: String,
            orderNumber: String,
            goods: Array<Goods>,
            settlementPayments: Array<SettlementPayment>? = nil
    ) {
        DataHolder.purchaseAmount = String(purchaseAmount)
        DataHolder.orderNumber = orderNumber
        DataHolder.invoiceId = invoiceId
        DataHolder.goods = goods
        DataHolder.settlementPayments = settlementPayments

        DataHolder.purchaseAmountFormatted = Money.initInt(amount: purchaseAmount).getFormatted()
    }
}
