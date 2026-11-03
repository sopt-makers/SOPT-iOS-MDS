//
//  MDSIcon.swift
//  MDS
//
//  Created by 최주리 on 5/17/26.
//

import UIKit

public enum MDSIcon: String, CaseIterable, Sendable {
    case calendarDateFilled = "icon.CalendarDate.filled"
    case calendarDateOutlined = "icon.CalendarDate.outlined"
    case facebookFilled = "icon.Facebook.filled"
    case alarmFilled = "icon.alarm.filled"
    case alarmOutlined = "icon.alarm.outlined"
    case alarmCheckFilled = "icon.alarmCheck.filled"
    case alarmCheckOutlined = "icon.alarmCheck.outlined"
    case alarmMinusFilled = "icon.alarmMinus.filled"
    case alarmMinusOutlined = "icon.alarmMinus.outlined"
    case alarmOffFilled = "icon.alarmOff.filled"
    case alarmOffOutlined = "icon.alarmOff.outlined"
    case alarmPlusFilled = "icon.alarmPlus.filled"
    case alarmPlusOutlined = "icon.alarmPlus.outlined"
    case alertCircleFilled = "icon.alertCircle.filled"
    case alertCircleOutlined = "icon.alertCircle.outlined"
    case alertTriangleFilled = "icon.alertTriangle.filled"
    case alertTriangleOutlined = "icon.alertTriangle.outlined"
    case alignCenterOutlined = "icon.alignCenter.outlined"
    case alignJustifyOutlined = "icon.alignJustify.outlined"
    case alignLeftOutlined = "icon.alignLeft.outlined"
    case alignRightOutlined = "icon.alignRight.outlined"
    case appleFilled = "icon.apple.filled"
    case archiveFilled = "icon.archive.filled"
    case archiveOutlined = "icon.archive.outlined"
    case arrowDownOutlined = "icon.arrowDown.outlined"
    case arrowDownLeftOutlined = "icon.arrowDownLeft.outlined"
    case arrowDownRightOutlined = "icon.arrowDownRight.outlined"
    case arrowLeftOutlined = "icon.arrowLeft.outlined"
    case arrowRightOutlined = "icon.arrowRight.outlined"
    case arrowUpOutlined = "icon.arrowUp.outlined"
    case arrowUpLeftOutlined = "icon.arrowUpLeft.outlined"
    case arrowUpRightOutlined = "icon.arrowUpRight.outlined"
    case attachmentOutlined = "icon.attachment.outlined"
    case behanceFilled = "icon.behance.filled"
    case bellFilled = "icon.bell.filled"
    case bellOutlined = "icon.bell.outlined"
    case bellActiveFilled = "icon.bellActive.filled"
    case bellActiveOutlined = "icon.bellActive.outlined"
    case bellOffFilled = "icon.bellOff.filled"
    case bellOffOutlined = "icon.bellOff.outlined"
    case birthFilled = "icon.birth.filled"
    case birthOutlined = "icon.birth.outlined"
    case boldOutlined = "icon.bold.outlined"
    case bookmarkFilled = "icon.bookmark.filled"
    case bookmarkOutlined = "icon.bookmark.outlined"
    case calendarFilled = "icon.calendar.filled"
    case calendarOutlined = "icon.calendar.outlined"
    case calendarCheckFilled = "icon.calendarCheck.filled"
    case calendarCheckOutlined = "icon.calendarCheck.outlined"
    case calendarPlusFilled = "icon.calendarPlus.filled"
    case calendarPlusOutlined = "icon.calendarPlus.outlined"
    case cameraFilled = "icon.camera.filled"
    case cameraOutlined = "icon.camera.outlined"
    case cameraOffFilled = "icon.cameraOff.filled"
    case cameraOffOutlined = "icon.cameraOff.outlined"
    case cameraPlusFilled = "icon.cameraPlus.filled"
    case cameraPlusOutlined = "icon.cameraPlus.outlined"
    case checkOutlined = "icon.check.outlined"
    case checkCircleFilled = "icon.checkCircle.filled"
    case checkCircleOutlined = "icon.checkCircle.outlined"
    case checkSquareFilled = "icon.checkSquare.filled"
    case checkSquareOutlined = "icon.checkSquare.outlined"
    case chevronDownOutlined = "icon.chevronDown.outlined"
    case chevronLeftOutlined = "icon.chevronLeft.outlined"
    case chevronRightOutlined = "icon.chevronRight.outlined"
    case chevronUpOutlined = "icon.chevronUp.outlined"
    case clapDefaultOutlined = "icon.clapDefault.outlined"
    case clapRoundOutlined = "icon.clapRound.outlined"
    case clockFilled = "icon.clock.filled"
    case clockOutlined = "icon.clock.outlined"
    case clockCheckFilled = "icon.clockCheck.filled"
    case clockCheckOutlined = "icon.clockCheck.outlined"
    case clockPlusFilled = "icon.clockPlus.filled"
    case clockPlusOutlined = "icon.clockPlus.outlined"
    case clockSnoozeFilled = "icon.clockSnooze.filled"
    case clockSnoozeOutlined = "icon.clockSnooze.outlined"
    case codeOutlined = "icon.code.outlined"
    case copyFilled = "icon.copy.filled"
    case copyOutlined = "icon.copy.outlined"
    case deleteFilled = "icon.delete.filled"
    case deleteOutlined = "icon.delete.outlined"
    case dotpointsOutlined = "icon.dotpoints.outlined"
    case dotsHorizontalOutlined = "icon.dotsHorizontal.outlined"
    case dotsVerticalOutlined = "icon.dotsVertical.outlined"
    case downloadOutlined = "icon.download.outlined"
    case downloadCloudOutlined = "icon.downloadCloud.outlined"
    case drawOutlined = "icon.draw.outlined"
    case editFilled = "icon.edit.filled"
    case editOutlined = "icon.edit.outlined"
    case eyeFilled = "icon.eye.filled"
    case eyeOutlined = "icon.eye.outlined"
    case eyeOffFilled = "icon.eyeOff.filled"
    case eyeOffOutlined = "icon.eyeOff.outlined"
    case fileFilled = "icon.file.filled"
    case fileOutlined = "icon.file.outlined"
    case fileCheckFilled = "icon.fileCheck.filled"
    case fileCheckOutlined = "icon.fileCheck.outlined"
    case fileDownloadFilled = "icon.fileDownload.filled"
    case fileDownloadOutlined = "icon.fileDownload.outlined"
    case fileMinusFilled = "icon.fileMinus.filled"
    case fileMinusOutlined = "icon.fileMinus.outlined"
    case filePlusFilled = "icon.filePlus.filled"
    case filePlusOutlined = "icon.filePlus.outlined"
    case fileSearchFilled = "icon.fileSearch.filled"
    case fileSearchOutlined = "icon.fileSearch.outlined"
    case fileTextFilled = "icon.fileText.filled"
    case fileTextOutlined = "icon.fileText.outlined"
    case fileXFilled = "icon.fileX.filled"
    case fileXOutlined = "icon.fileX.outlined"
    case flipBackwardOutlined = "icon.flipBackward.outlined"
    case flipForwardOutlined = "icon.flipForward.outlined"
    case folderFilled = "icon.folder.filled"
    case folderOutlined = "icon.folder.outlined"
    case folderCheckFilled = "icon.folderCheck.filled"
    case folderCheckOutlined = "icon.folderCheck.outlined"
    case folderDownloadFilled = "icon.folderDownload.filled"
    case folderDownloadOutlined = "icon.folderDownload.outlined"
    case githubFilled = "icon.github.filled"
    case googleColorFilled = "icon.googleColor.filled"
    case googleMonoFilled = "icon.googleMono.filled"
    case heartFilled = "icon.heart.filled"
    case heartOutlined = "icon.heart.outlined"
    case helpCircleFilled = "icon.helpCircle.filled"
    case helpCircleOutlined = "icon.helpCircle.outlined"
    case homeFilled = "icon.home.filled"
    case homeOutlined = "icon.home.outlined"
    case imageCheckFilled = "icon.imageCheck.filled"
    case imageCheckOutlined = "icon.imageCheck.outlined"
    case imageFilled = "icon.image.filled"
    case imageOutlined = "icon.image.outlined"
    case imageDownFilled = "icon.imageDown.filled"
    case imageDownOutlined = "icon.imageDown.outlined"
    case imageLeftFilled = "icon.imageLeft.filled"
    case imageLeftOutlined = "icon.imageLeft.outlined"
    case imagePlusFilled = "icon.imagePlus.filled"
    case imagePlusOutlined = "icon.imagePlus.outlined"
    case imageRightFilled = "icon.imageRight.filled"
    case imageRightOutlined = "icon.imageRight.outlined"
    case imageUpFilled = "icon.imageUp.filled"
    case imageUpOutlined = "icon.imageUp.outlined"
    case infoCircleFilled = "icon.infoCircle.filled"
    case infoCircleOutlined = "icon.infoCircle.outlined"
    case instagramFilled = "icon.instagram.filled"
    case italicOutlined = "icon.italic.outlined"
    case kakaoFilled = "icon.kakao.filled"
    case leftIndentOutlined = "icon.leftIndent.outlined"
    case letterSpacingOutlined = "icon.letterSpacing.outlined"
    case lineHeightOutlined = "icon.lineHeight.outlined"
    case linkOutlined = "icon.link.outlined"
    case linkedinFilled = "icon.linkedin.filled"
    case locationFilled = "icon.location.filled"
    case locationOutlined = "icon.location.outlined"
    case lockFilled = "icon.lock.filled"
    case lockOutlined = "icon.lock.outlined"
    case logInOutlined = "icon.logIn.outlined"
    case logOutOutlined = "icon.logOut.outlined"
    case mailFilled = "icon.mail.filled"
    case mailOutlined = "icon.mail.outlined"
    case mentoFilled = "icon.mento.filled"
    case mentoOutlined = "icon.mento.outlined"
    case menuOutlined = "icon.menu.outlined"
    case messageCheckFilled = "icon.messageCheck.filled"
    case messageCheckOutlined = "icon.messageCheck.outlined"
    case messageFilled = "icon.message.filled"
    case messageOutlined = "icon.message.outlined"
    case messageAlertFilled = "icon.messageAlert.filled"
    case messageAlertOutlined = "icon.messageAlert.outlined"
    case messageChatFilled = "icon.messageChat.filled"
    case messageChatOutlined = "icon.messageChat.outlined"
    case messageDotsFilled = "icon.messageDots.filled"
    case messageDotsOutlined = "icon.messageDots.outlined"
    case messagePlusFilled = "icon.messagePlus.filled"
    case messagePlusOutlined = "icon.messagePlus.outlined"
    case messageQuestionFilled = "icon.messageQuestion.filled"
    case messageQuestionOutlined = "icon.messageQuestion.outlined"
    case messageTextFilled = "icon.messageText.filled"
    case messageTextOutlined = "icon.messageText.outlined"
    case messageXFilled = "icon.messageX.filled"
    case messageXOutlined = "icon.messageX.outlined"
    case paragraphSpacingOutlined = "icon.paragraphSpacing.outlined"
    case paragraphWrapOutlined = "icon.paragraphWrap.outlined"
    case phoneFilled = "icon.phone.filled"
    case phoneOutlined = "icon.phone.outlined"
    case pinFilled = "icon.pin.filled"
    case pinOutlined = "icon.pin.outlined"
    case playstoreFilled = "icon.playstore.filled"
    case plusOutlined = "icon.plus.outlined"
    case plusCircleFilled = "icon.plusCircle.filled"
    case plusCircleOutlined = "icon.plusCircle.outlined"
    case plusSquareFilled = "icon.plusSquare.filled"
    case plusSquareOutlined = "icon.plusSquare.outlined"
    case powerOutlined = "icon.power.outlined"
    case refreshOutlined = "icon.refresh.outlined"
    case repeatOutlined = "icon.repeat.outlined"
    case replyOutlined = "icon.reply.outlined"
    case rightIndentOutlined = "icon.rightIndent.outlined"
    case searchFilled = "icon.search.filled"
    case searchOutlined = "icon.search.outlined"
    case sendFilled = "icon.send.filled"
    case sendOutlined = "icon.send.outlined"
    case settingsFilled = "icon.settings.filled"
    case settingsOutlined = "icon.settings.outlined"
    case shareOutlined = "icon.share.outlined"
    case slidersOutlined = "icon.sliders.outlined"
    case switchHorizontalOutlined = "icon.switchHorizontal.outlined"
    case switchVerticalOutlined = "icon.switchVertical.outlined"
    case thumbsDownFilled = "icon.thumbsDown.filled"
    case thumbsDownOutlined = "icon.thumbsDown.outlined"
    case thumbsUpFilled = "icon.thumbsUp.filled"
    case thumbsUpOutlined = "icon.thumbsUp.outlined"
    case trashFilled = "icon.trash.filled"
    case trashOutlined = "icon.trash.outlined"
    case trophyOutlined = "icon.trophy.outlined"
    case typeOutlined = "icon.type.outlined"
    case typeStrikethroughOutlined = "icon.typeStrikethrough.outlined"
    case underlineOutlined = "icon.underline.outlined"
    case unlockFilled = "icon.unlock.filled"
    case unlockOutlined = "icon.unlock.outlined"
    case uploadCloudOutlined = "icon.uploadCloud.outlined"
    case userFilled = "icon.user.filled"
    case userOutlined = "icon.user.outlined"
    case userCheckFilled = "icon.userCheck.filled"
    case userCheckOutlined = "icon.userCheck.outlined"
    case userEditFilled = "icon.userEdit.filled"
    case userEditOutlined = "icon.userEdit.outlined"
    case userMinusFilled = "icon.userMinus.filled"
    case userMinusOutlined = "icon.userMinus.outlined"
    case userPlusFilled = "icon.userPlus.filled"
    case userPlusOutlined = "icon.userPlus.outlined"
    case userXFilled = "icon.userX.filled"
    case userXOutlined = "icon.userX.outlined"
    case usersFilled = "icon.users.filled"
    case usersOutlined = "icon.users.outlined"
    case usersCheckFilled = "icon.usersCheck.filled"
    case usersCheckOutlined = "icon.usersCheck.outlined"
    case usersMinusFilled = "icon.usersMinus.filled"
    case usersMinusOutlined = "icon.usersMinus.outlined"
    case usersPlusFilled = "icon.usersPlus.filled"
    case usersPlusOutlined = "icon.usersPlus.outlined"
    case usersXFilled = "icon.usersX.filled"
    case usersXOutlined = "icon.usersX.outlined"
    case videoFilled = "icon.video.filled"
    case videoOutlined = "icon.video.outlined"
    case videoOffFilled = "icon.videoOff.filled"
    case videoOffOutlined = "icon.videoOff.outlined"
    case writeFilled = "icon.write.filled"
    case writeOutlined = "icon.write.outlined"
    case xCircleFilled = "icon.xCircle.filled"
    case xCircleOutlined = "icon.xCircle.outlined"
    case xCloseOutlined = "icon.xClose.outlined"
    case zoomInFilled = "icon.zoomIn.filled"
    case zoomInOutlined = "icon.zoomIn.outlined"
    case zoomOutFilled = "icon.zoomOut.filled"
    case zoomOutOutlined = "icon.zoomOut.outlined"

    public var image: UIImage {
        UIImage(named: rawValue, in: .module, compatibleWith: nil) ?? UIImage()
    }
}

// MARK: - Tint

public extension MDSIcon {

    /// 컴포넌트가 아이콘에 색을 입히는 방식입니다.
    enum Tint {
        /// 컴포넌트의 foreground 색을 따라갑니다.
        case automatic
        /// asset 원본 색상을 유지합니다. 브랜드/멀티컬러 아이콘에 사용합니다.
        case original
    }
}

// MARK: - Category

/// Figma 아이콘 페이지의 섹션 구분입니다.
///
/// 카테고리 멤버는 기존 case와 같은 `MDSIcon` 값이므로 두 방식 모두 사용할 수 있습니다.
/// ```swift
/// MDSIcon.imageFilled.image        // 기존 방식
/// MDSIcon.Media.imageFilled.image  // 카테고리 방식 (같은 값)
/// chip.prefixIcon = .Media.imageFilled  // MDSIcon 타입 자리에서는 축약 가능
/// ```
public extension MDSIcon {
    enum Communication {
        public static let messageChatFilled: MDSIcon = .messageChatFilled
        public static let messageChatOutlined: MDSIcon = .messageChatOutlined
        public static let messageCheckFilled: MDSIcon = .messageCheckFilled
        public static let messageCheckOutlined: MDSIcon = .messageCheckOutlined
        public static let messageDotsFilled: MDSIcon = .messageDotsFilled
        public static let messageDotsOutlined: MDSIcon = .messageDotsOutlined
        public static let messagePlusFilled: MDSIcon = .messagePlusFilled
        public static let messagePlusOutlined: MDSIcon = .messagePlusOutlined
        public static let messageQuestionFilled: MDSIcon = .messageQuestionFilled
        public static let messageQuestionOutlined: MDSIcon = .messageQuestionOutlined
        public static let messageTextFilled: MDSIcon = .messageTextFilled
        public static let messageTextOutlined: MDSIcon = .messageTextOutlined
        public static let messageXFilled: MDSIcon = .messageXFilled
        public static let messageXOutlined: MDSIcon = .messageXOutlined
        public static let phoneFilled: MDSIcon = .phoneFilled
        public static let phoneOutlined: MDSIcon = .phoneOutlined
        public static let pinFilled: MDSIcon = .pinFilled
        public static let pinOutlined: MDSIcon = .pinOutlined
        public static let sendFilled: MDSIcon = .sendFilled
        public static let sendOutlined: MDSIcon = .sendOutlined
        public static let trophyOutlined: MDSIcon = .trophyOutlined
        public static let archiveFilled: MDSIcon = .archiveFilled
        public static let archiveOutlined: MDSIcon = .archiveOutlined
        public static let birthFilled: MDSIcon = .birthFilled
        public static let birthOutlined: MDSIcon = .birthOutlined
        public static let bookmarkFilled: MDSIcon = .bookmarkFilled
        public static let bookmarkOutlined: MDSIcon = .bookmarkOutlined
        public static let editFilled: MDSIcon = .editFilled
        public static let editOutlined: MDSIcon = .editOutlined
        public static let eyeFilled: MDSIcon = .eyeFilled
        public static let eyeOutlined: MDSIcon = .eyeOutlined
        public static let eyeOffFilled: MDSIcon = .eyeOffFilled
        public static let eyeOffOutlined: MDSIcon = .eyeOffOutlined
        public static let locationFilled: MDSIcon = .locationFilled
        public static let locationOutlined: MDSIcon = .locationOutlined
        public static let mailFilled: MDSIcon = .mailFilled
        public static let mailOutlined: MDSIcon = .mailOutlined
        public static let mentoFilled: MDSIcon = .mentoFilled
        public static let mentoOutlined: MDSIcon = .mentoOutlined
        public static let messageFilled: MDSIcon = .messageFilled
        public static let messageOutlined: MDSIcon = .messageOutlined
        public static let messageAlertFilled: MDSIcon = .messageAlertFilled
        public static let messageAlertOutlined: MDSIcon = .messageAlertOutlined
        public static let clapDefaultOutlined: MDSIcon = .clapDefaultOutlined
        public static let clapRoundOutlined: MDSIcon = .clapRoundOutlined

        public static let all: [MDSIcon] = [
            .messageChatFilled,
            .messageChatOutlined,
            .messageCheckFilled,
            .messageCheckOutlined,
            .messageDotsFilled,
            .messageDotsOutlined,
            .messagePlusFilled,
            .messagePlusOutlined,
            .messageQuestionFilled,
            .messageQuestionOutlined,
            .messageTextFilled,
            .messageTextOutlined,
            .messageXFilled,
            .messageXOutlined,
            .phoneFilled,
            .phoneOutlined,
            .pinFilled,
            .pinOutlined,
            .sendFilled,
            .sendOutlined,
            .trophyOutlined,
            .archiveFilled,
            .archiveOutlined,
            .birthFilled,
            .birthOutlined,
            .bookmarkFilled,
            .bookmarkOutlined,
            .editFilled,
            .editOutlined,
            .eyeFilled,
            .eyeOutlined,
            .eyeOffFilled,
            .eyeOffOutlined,
            .locationFilled,
            .locationOutlined,
            .mailFilled,
            .mailOutlined,
            .mentoFilled,
            .mentoOutlined,
            .messageFilled,
            .messageOutlined,
            .messageAlertFilled,
            .messageAlertOutlined,
            .clapDefaultOutlined,
            .clapRoundOutlined,
        ]
    }

    enum Editor {
        public static let alignCenterOutlined: MDSIcon = .alignCenterOutlined
        public static let alignJustifyOutlined: MDSIcon = .alignJustifyOutlined
        public static let alignLeftOutlined: MDSIcon = .alignLeftOutlined
        public static let alignRightOutlined: MDSIcon = .alignRightOutlined
        public static let attachmentOutlined: MDSIcon = .attachmentOutlined
        public static let boldOutlined: MDSIcon = .boldOutlined
        public static let codeOutlined: MDSIcon = .codeOutlined
        public static let deleteFilled: MDSIcon = .deleteFilled
        public static let deleteOutlined: MDSIcon = .deleteOutlined
        public static let dotpointsOutlined: MDSIcon = .dotpointsOutlined
        public static let italicOutlined: MDSIcon = .italicOutlined
        public static let leftIndentOutlined: MDSIcon = .leftIndentOutlined
        public static let letterSpacingOutlined: MDSIcon = .letterSpacingOutlined
        public static let lineHeightOutlined: MDSIcon = .lineHeightOutlined
        public static let paragraphSpacingOutlined: MDSIcon = .paragraphSpacingOutlined
        public static let paragraphWrapOutlined: MDSIcon = .paragraphWrapOutlined
        public static let rightIndentOutlined: MDSIcon = .rightIndentOutlined
        public static let typeOutlined: MDSIcon = .typeOutlined
        public static let typeStrikethroughOutlined: MDSIcon = .typeStrikethroughOutlined
        public static let underlineOutlined: MDSIcon = .underlineOutlined
        public static let writeFilled: MDSIcon = .writeFilled
        public static let writeOutlined: MDSIcon = .writeOutlined
        public static let drawOutlined: MDSIcon = .drawOutlined
        public static let zoomInFilled: MDSIcon = .zoomInFilled
        public static let zoomInOutlined: MDSIcon = .zoomInOutlined
        public static let zoomOutFilled: MDSIcon = .zoomOutFilled
        public static let zoomOutOutlined: MDSIcon = .zoomOutOutlined

        public static let all: [MDSIcon] = [
            .alignCenterOutlined,
            .alignJustifyOutlined,
            .alignLeftOutlined,
            .alignRightOutlined,
            .attachmentOutlined,
            .boldOutlined,
            .codeOutlined,
            .deleteFilled,
            .deleteOutlined,
            .dotpointsOutlined,
            .italicOutlined,
            .leftIndentOutlined,
            .letterSpacingOutlined,
            .lineHeightOutlined,
            .paragraphSpacingOutlined,
            .paragraphWrapOutlined,
            .rightIndentOutlined,
            .typeOutlined,
            .typeStrikethroughOutlined,
            .underlineOutlined,
            .writeFilled,
            .writeOutlined,
            .drawOutlined,
            .zoomInFilled,
            .zoomInOutlined,
            .zoomOutFilled,
            .zoomOutOutlined,
        ]
    }

    enum Feedback {
        public static let alertCircleFilled: MDSIcon = .alertCircleFilled
        public static let alertCircleOutlined: MDSIcon = .alertCircleOutlined
        public static let alertTriangleFilled: MDSIcon = .alertTriangleFilled
        public static let alertTriangleOutlined: MDSIcon = .alertTriangleOutlined
        public static let bellFilled: MDSIcon = .bellFilled
        public static let bellOutlined: MDSIcon = .bellOutlined
        public static let bellOffFilled: MDSIcon = .bellOffFilled
        public static let bellOffOutlined: MDSIcon = .bellOffOutlined
        public static let bellActiveFilled: MDSIcon = .bellActiveFilled
        public static let bellActiveOutlined: MDSIcon = .bellActiveOutlined
        public static let helpCircleFilled: MDSIcon = .helpCircleFilled
        public static let helpCircleOutlined: MDSIcon = .helpCircleOutlined
        public static let infoCircleFilled: MDSIcon = .infoCircleFilled
        public static let infoCircleOutlined: MDSIcon = .infoCircleOutlined
        public static let thumbsDownFilled: MDSIcon = .thumbsDownFilled
        public static let thumbsDownOutlined: MDSIcon = .thumbsDownOutlined
        public static let thumbsUpFilled: MDSIcon = .thumbsUpFilled
        public static let thumbsUpOutlined: MDSIcon = .thumbsUpOutlined

        public static let all: [MDSIcon] = [
            .alertCircleFilled,
            .alertCircleOutlined,
            .alertTriangleFilled,
            .alertTriangleOutlined,
            .bellFilled,
            .bellOutlined,
            .bellOffFilled,
            .bellOffOutlined,
            .bellActiveFilled,
            .bellActiveOutlined,
            .helpCircleFilled,
            .helpCircleOutlined,
            .infoCircleFilled,
            .infoCircleOutlined,
            .thumbsDownFilled,
            .thumbsDownOutlined,
            .thumbsUpFilled,
            .thumbsUpOutlined,
        ]
    }

    enum Files {
        public static let fileFilled: MDSIcon = .fileFilled
        public static let fileOutlined: MDSIcon = .fileOutlined
        public static let fileCheckFilled: MDSIcon = .fileCheckFilled
        public static let fileCheckOutlined: MDSIcon = .fileCheckOutlined
        public static let fileDownloadFilled: MDSIcon = .fileDownloadFilled
        public static let fileDownloadOutlined: MDSIcon = .fileDownloadOutlined
        public static let fileMinusFilled: MDSIcon = .fileMinusFilled
        public static let fileMinusOutlined: MDSIcon = .fileMinusOutlined
        public static let filePlusFilled: MDSIcon = .filePlusFilled
        public static let filePlusOutlined: MDSIcon = .filePlusOutlined
        public static let fileSearchFilled: MDSIcon = .fileSearchFilled
        public static let fileSearchOutlined: MDSIcon = .fileSearchOutlined
        public static let fileTextFilled: MDSIcon = .fileTextFilled
        public static let fileTextOutlined: MDSIcon = .fileTextOutlined
        public static let fileXFilled: MDSIcon = .fileXFilled
        public static let fileXOutlined: MDSIcon = .fileXOutlined
        public static let folderFilled: MDSIcon = .folderFilled
        public static let folderOutlined: MDSIcon = .folderOutlined
        public static let folderCheckFilled: MDSIcon = .folderCheckFilled
        public static let folderCheckOutlined: MDSIcon = .folderCheckOutlined
        public static let folderDownloadFilled: MDSIcon = .folderDownloadFilled
        public static let folderDownloadOutlined: MDSIcon = .folderDownloadOutlined

        public static let all: [MDSIcon] = [
            .fileFilled,
            .fileOutlined,
            .fileCheckFilled,
            .fileCheckOutlined,
            .fileDownloadFilled,
            .fileDownloadOutlined,
            .fileMinusFilled,
            .fileMinusOutlined,
            .filePlusFilled,
            .filePlusOutlined,
            .fileSearchFilled,
            .fileSearchOutlined,
            .fileTextFilled,
            .fileTextOutlined,
            .fileXFilled,
            .fileXOutlined,
            .folderFilled,
            .folderOutlined,
            .folderCheckFilled,
            .folderCheckOutlined,
            .folderDownloadFilled,
            .folderDownloadOutlined,
        ]
    }

    enum General {
        public static let copyFilled: MDSIcon = .copyFilled
        public static let copyOutlined: MDSIcon = .copyOutlined
        public static let dotsHorizontalOutlined: MDSIcon = .dotsHorizontalOutlined
        public static let dotsVerticalOutlined: MDSIcon = .dotsVerticalOutlined
        public static let downloadOutlined: MDSIcon = .downloadOutlined
        public static let downloadCloudOutlined: MDSIcon = .downloadCloudOutlined
        public static let homeFilled: MDSIcon = .homeFilled
        public static let homeOutlined: MDSIcon = .homeOutlined
        public static let linkOutlined: MDSIcon = .linkOutlined
        public static let lockFilled: MDSIcon = .lockFilled
        public static let lockOutlined: MDSIcon = .lockOutlined
        public static let logInOutlined: MDSIcon = .logInOutlined
        public static let logOutOutlined: MDSIcon = .logOutOutlined
        public static let menuOutlined: MDSIcon = .menuOutlined
        public static let searchFilled: MDSIcon = .searchFilled
        public static let searchOutlined: MDSIcon = .searchOutlined
        public static let settingsFilled: MDSIcon = .settingsFilled
        public static let settingsOutlined: MDSIcon = .settingsOutlined
        public static let shareOutlined: MDSIcon = .shareOutlined
        public static let slidersOutlined: MDSIcon = .slidersOutlined
        public static let trashFilled: MDSIcon = .trashFilled
        public static let trashOutlined: MDSIcon = .trashOutlined
        public static let unlockFilled: MDSIcon = .unlockFilled
        public static let unlockOutlined: MDSIcon = .unlockOutlined
        public static let uploadCloudOutlined: MDSIcon = .uploadCloudOutlined

        public static let all: [MDSIcon] = [
            .copyFilled,
            .copyOutlined,
            .dotsHorizontalOutlined,
            .dotsVerticalOutlined,
            .downloadOutlined,
            .downloadCloudOutlined,
            .homeFilled,
            .homeOutlined,
            .linkOutlined,
            .lockFilled,
            .lockOutlined,
            .logInOutlined,
            .logOutOutlined,
            .menuOutlined,
            .searchFilled,
            .searchOutlined,
            .settingsFilled,
            .settingsOutlined,
            .shareOutlined,
            .slidersOutlined,
            .trashFilled,
            .trashOutlined,
            .unlockFilled,
            .unlockOutlined,
            .uploadCloudOutlined,
        ]
    }

    enum Interaction {
        public static let arrowDownOutlined: MDSIcon = .arrowDownOutlined
        public static let arrowDownLeftOutlined: MDSIcon = .arrowDownLeftOutlined
        public static let arrowDownRightOutlined: MDSIcon = .arrowDownRightOutlined
        public static let arrowLeftOutlined: MDSIcon = .arrowLeftOutlined
        public static let arrowRightOutlined: MDSIcon = .arrowRightOutlined
        public static let arrowUpOutlined: MDSIcon = .arrowUpOutlined
        public static let arrowUpLeftOutlined: MDSIcon = .arrowUpLeftOutlined
        public static let arrowUpRightOutlined: MDSIcon = .arrowUpRightOutlined
        public static let checkOutlined: MDSIcon = .checkOutlined
        public static let checkCircleFilled: MDSIcon = .checkCircleFilled
        public static let checkCircleOutlined: MDSIcon = .checkCircleOutlined
        public static let checkSquareFilled: MDSIcon = .checkSquareFilled
        public static let checkSquareOutlined: MDSIcon = .checkSquareOutlined
        public static let chevronDownOutlined: MDSIcon = .chevronDownOutlined
        public static let chevronLeftOutlined: MDSIcon = .chevronLeftOutlined
        public static let chevronRightOutlined: MDSIcon = .chevronRightOutlined
        public static let chevronUpOutlined: MDSIcon = .chevronUpOutlined
        public static let flipBackwardOutlined: MDSIcon = .flipBackwardOutlined
        public static let flipForwardOutlined: MDSIcon = .flipForwardOutlined
        public static let heartFilled: MDSIcon = .heartFilled
        public static let heartOutlined: MDSIcon = .heartOutlined
        public static let plusOutlined: MDSIcon = .plusOutlined
        public static let plusCircleFilled: MDSIcon = .plusCircleFilled
        public static let plusCircleOutlined: MDSIcon = .plusCircleOutlined
        public static let plusSquareFilled: MDSIcon = .plusSquareFilled
        public static let plusSquareOutlined: MDSIcon = .plusSquareOutlined
        public static let refreshOutlined: MDSIcon = .refreshOutlined
        public static let replyOutlined: MDSIcon = .replyOutlined
        public static let switchHorizontalOutlined: MDSIcon = .switchHorizontalOutlined
        public static let switchVerticalOutlined: MDSIcon = .switchVerticalOutlined
        public static let xCircleFilled: MDSIcon = .xCircleFilled
        public static let xCircleOutlined: MDSIcon = .xCircleOutlined
        public static let xCloseOutlined: MDSIcon = .xCloseOutlined

        public static let all: [MDSIcon] = [
            .arrowDownOutlined,
            .arrowDownLeftOutlined,
            .arrowDownRightOutlined,
            .arrowLeftOutlined,
            .arrowRightOutlined,
            .arrowUpOutlined,
            .arrowUpLeftOutlined,
            .arrowUpRightOutlined,
            .checkOutlined,
            .checkCircleFilled,
            .checkCircleOutlined,
            .checkSquareFilled,
            .checkSquareOutlined,
            .chevronDownOutlined,
            .chevronLeftOutlined,
            .chevronRightOutlined,
            .chevronUpOutlined,
            .flipBackwardOutlined,
            .flipForwardOutlined,
            .heartFilled,
            .heartOutlined,
            .plusOutlined,
            .plusCircleFilled,
            .plusCircleOutlined,
            .plusSquareFilled,
            .plusSquareOutlined,
            .refreshOutlined,
            .replyOutlined,
            .switchHorizontalOutlined,
            .switchVerticalOutlined,
            .xCircleFilled,
            .xCircleOutlined,
            .xCloseOutlined,
        ]
    }

    enum Media {
        public static let cameraFilled: MDSIcon = .cameraFilled
        public static let cameraOutlined: MDSIcon = .cameraOutlined
        public static let cameraOffFilled: MDSIcon = .cameraOffFilled
        public static let cameraOffOutlined: MDSIcon = .cameraOffOutlined
        public static let cameraPlusFilled: MDSIcon = .cameraPlusFilled
        public static let cameraPlusOutlined: MDSIcon = .cameraPlusOutlined
        public static let imageFilled: MDSIcon = .imageFilled
        public static let imageOutlined: MDSIcon = .imageOutlined
        public static let imageCheckFilled: MDSIcon = .imageCheckFilled
        public static let imageCheckOutlined: MDSIcon = .imageCheckOutlined
        public static let imageDownFilled: MDSIcon = .imageDownFilled
        public static let imageDownOutlined: MDSIcon = .imageDownOutlined
        public static let imageLeftFilled: MDSIcon = .imageLeftFilled
        public static let imageLeftOutlined: MDSIcon = .imageLeftOutlined
        public static let imagePlusFilled: MDSIcon = .imagePlusFilled
        public static let imagePlusOutlined: MDSIcon = .imagePlusOutlined
        public static let imageRightFilled: MDSIcon = .imageRightFilled
        public static let imageRightOutlined: MDSIcon = .imageRightOutlined
        public static let imageUpFilled: MDSIcon = .imageUpFilled
        public static let imageUpOutlined: MDSIcon = .imageUpOutlined
        public static let powerOutlined: MDSIcon = .powerOutlined
        public static let repeatOutlined: MDSIcon = .repeatOutlined
        public static let videoFilled: MDSIcon = .videoFilled
        public static let videoOutlined: MDSIcon = .videoOutlined
        public static let videoOffFilled: MDSIcon = .videoOffFilled
        public static let videoOffOutlined: MDSIcon = .videoOffOutlined

        public static let all: [MDSIcon] = [
            .cameraFilled,
            .cameraOutlined,
            .cameraOffFilled,
            .cameraOffOutlined,
            .cameraPlusFilled,
            .cameraPlusOutlined,
            .imageFilled,
            .imageOutlined,
            .imageCheckFilled,
            .imageCheckOutlined,
            .imageDownFilled,
            .imageDownOutlined,
            .imageLeftFilled,
            .imageLeftOutlined,
            .imagePlusFilled,
            .imagePlusOutlined,
            .imageRightFilled,
            .imageRightOutlined,
            .imageUpFilled,
            .imageUpOutlined,
            .powerOutlined,
            .repeatOutlined,
            .videoFilled,
            .videoOutlined,
            .videoOffFilled,
            .videoOffOutlined,
        ]
    }

    enum Time {
        public static let alarmFilled: MDSIcon = .alarmFilled
        public static let alarmOutlined: MDSIcon = .alarmOutlined
        public static let alarmCheckFilled: MDSIcon = .alarmCheckFilled
        public static let alarmCheckOutlined: MDSIcon = .alarmCheckOutlined
        public static let alarmMinusFilled: MDSIcon = .alarmMinusFilled
        public static let alarmMinusOutlined: MDSIcon = .alarmMinusOutlined
        public static let alarmOffFilled: MDSIcon = .alarmOffFilled
        public static let alarmOffOutlined: MDSIcon = .alarmOffOutlined
        public static let alarmPlusFilled: MDSIcon = .alarmPlusFilled
        public static let alarmPlusOutlined: MDSIcon = .alarmPlusOutlined
        public static let calendarFilled: MDSIcon = .calendarFilled
        public static let calendarOutlined: MDSIcon = .calendarOutlined
        public static let calendarCheckFilled: MDSIcon = .calendarCheckFilled
        public static let calendarCheckOutlined: MDSIcon = .calendarCheckOutlined
        public static let calendarPlusFilled: MDSIcon = .calendarPlusFilled
        public static let calendarPlusOutlined: MDSIcon = .calendarPlusOutlined
        public static let calendarDateFilled: MDSIcon = .calendarDateFilled
        public static let calendarDateOutlined: MDSIcon = .calendarDateOutlined
        public static let clockFilled: MDSIcon = .clockFilled
        public static let clockOutlined: MDSIcon = .clockOutlined
        public static let clockCheckFilled: MDSIcon = .clockCheckFilled
        public static let clockCheckOutlined: MDSIcon = .clockCheckOutlined
        public static let clockPlusFilled: MDSIcon = .clockPlusFilled
        public static let clockPlusOutlined: MDSIcon = .clockPlusOutlined
        public static let clockSnoozeFilled: MDSIcon = .clockSnoozeFilled
        public static let clockSnoozeOutlined: MDSIcon = .clockSnoozeOutlined

        public static let all: [MDSIcon] = [
            .alarmFilled,
            .alarmOutlined,
            .alarmCheckFilled,
            .alarmCheckOutlined,
            .alarmMinusFilled,
            .alarmMinusOutlined,
            .alarmOffFilled,
            .alarmOffOutlined,
            .alarmPlusFilled,
            .alarmPlusOutlined,
            .calendarFilled,
            .calendarOutlined,
            .calendarCheckFilled,
            .calendarCheckOutlined,
            .calendarPlusFilled,
            .calendarPlusOutlined,
            .calendarDateFilled,
            .calendarDateOutlined,
            .clockFilled,
            .clockOutlined,
            .clockCheckFilled,
            .clockCheckOutlined,
            .clockPlusFilled,
            .clockPlusOutlined,
            .clockSnoozeFilled,
            .clockSnoozeOutlined,
        ]
    }

    enum Users {
        public static let userFilled: MDSIcon = .userFilled
        public static let userOutlined: MDSIcon = .userOutlined
        public static let userCheckFilled: MDSIcon = .userCheckFilled
        public static let userCheckOutlined: MDSIcon = .userCheckOutlined
        public static let userEditFilled: MDSIcon = .userEditFilled
        public static let userEditOutlined: MDSIcon = .userEditOutlined
        public static let userMinusFilled: MDSIcon = .userMinusFilled
        public static let userMinusOutlined: MDSIcon = .userMinusOutlined
        public static let userPlusFilled: MDSIcon = .userPlusFilled
        public static let userPlusOutlined: MDSIcon = .userPlusOutlined
        public static let userXFilled: MDSIcon = .userXFilled
        public static let userXOutlined: MDSIcon = .userXOutlined
        public static let usersFilled: MDSIcon = .usersFilled
        public static let usersOutlined: MDSIcon = .usersOutlined
        public static let usersCheckFilled: MDSIcon = .usersCheckFilled
        public static let usersCheckOutlined: MDSIcon = .usersCheckOutlined
        public static let usersMinusFilled: MDSIcon = .usersMinusFilled
        public static let usersMinusOutlined: MDSIcon = .usersMinusOutlined
        public static let usersPlusFilled: MDSIcon = .usersPlusFilled
        public static let usersPlusOutlined: MDSIcon = .usersPlusOutlined
        public static let usersXFilled: MDSIcon = .usersXFilled
        public static let usersXOutlined: MDSIcon = .usersXOutlined

        public static let all: [MDSIcon] = [
            .userFilled,
            .userOutlined,
            .userCheckFilled,
            .userCheckOutlined,
            .userEditFilled,
            .userEditOutlined,
            .userMinusFilled,
            .userMinusOutlined,
            .userPlusFilled,
            .userPlusOutlined,
            .userXFilled,
            .userXOutlined,
            .usersFilled,
            .usersOutlined,
            .usersCheckFilled,
            .usersCheckOutlined,
            .usersMinusFilled,
            .usersMinusOutlined,
            .usersPlusFilled,
            .usersPlusOutlined,
            .usersXFilled,
            .usersXOutlined,
        ]
    }

    enum Logo {
        public static let appleFilled: MDSIcon = .appleFilled
        public static let behanceFilled: MDSIcon = .behanceFilled
        public static let facebookFilled: MDSIcon = .facebookFilled
        public static let githubFilled: MDSIcon = .githubFilled
        public static let googleColorFilled: MDSIcon = .googleColorFilled
        public static let googleMonoFilled: MDSIcon = .googleMonoFilled
        public static let instagramFilled: MDSIcon = .instagramFilled
        public static let kakaoFilled: MDSIcon = .kakaoFilled
        public static let linkedinFilled: MDSIcon = .linkedinFilled
        public static let playstoreFilled: MDSIcon = .playstoreFilled

        public static let all: [MDSIcon] = [
            .appleFilled,
            .behanceFilled,
            .facebookFilled,
            .githubFilled,
            .googleColorFilled,
            .googleMonoFilled,
            .instagramFilled,
            .kakaoFilled,
            .linkedinFilled,
            .playstoreFilled,
        ]
    }
}
