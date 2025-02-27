//
// Created by Mikhail Belikov on 29.08.2023.
//

import Foundation
import Combine
import Alamofire

func createPaymentService(saveCard: Bool) async -> PaymentCreateResponse? {
    let params = initParamsForCreatePayment(saveCard: saveCard)
    return await executeRequest(params: params)
}

func createPaymentService(cardId: String) async -> PaymentCreateResponse? {
    let params = initParamsForCreatePayment(cardId: cardId)
    return await executeRequest(params: params, cardId: cardId)
}

func createPaymentService() async -> PaymentCreateResponse? {
    let params = initParamsForCreatePayment(cardId: nil)
    return await executeRequest(params: params)
}

private func executeRequest(
        params: PaymentCreateRequest,
        cardId: String? = nil
) async -> PaymentCreateResponse? {
    do {
        let data = try await NetworkManager.shared.post(
                path: cardId != nil ? "api/v1/payments/" + cardId! : "api/v1/payments",
                parameters: params
        )

        let result: PaymentCreateResponse = try Api.parseData(data: data)
        return result

    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

private func initParamsForCreatePayment(
        saveCard: Bool? = nil,
        cardId: String? = nil
) -> PaymentCreateRequest {

    PaymentCreateRequest(
            accountId: DataHolder.userPhone,
            invoiceId: DataHolder.invoiceId,
            orderNumber: DataHolder.orderNumber,
            cardId: cardId,
            language: DataHolder.currentLang == AirbaPaySdk.Lang.RU() ? "ru" : "kz",
            phone: DataHolder.userPhone,
            email: DataHolder.userEmail,
            failureBackUrl: DataHolder.failureBackUrl,
            failureCallback: DataHolder.failureCallback,
            successBackUrl: DataHolder.successBackUrl,
            successCallback: DataHolder.successCallback,
            amount: Double(DataHolder.purchaseAmount),
            cardSave: saveCard,
            settlement: DataHolder.settlementPayments != nil
                    ? SettlementPaymentsRequest(payments: DataHolder.settlementPayments!)
                    : nil,
            cart: DataHolder.goods!
    )
}
