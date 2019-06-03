//
//  SettingsVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift
import RxRealmDataSources

class SettingsVC: UITableViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var roomLbl: UILabel!
    @IBOutlet weak var sessionLbl: UILabel!
    
    @IBOutlet weak var saveSettingsAndExitBtn: UIButton!
    @IBOutlet weak var cancelSettingsBtn: UIBarButtonItem!
    
    //@IBOutlet weak var setIntervalForAutoSessionView: SetIntervalForAutoSessionView!
    
    @IBOutlet weak var autoSelectSessionsView: AutoSelectSessionsView!
    @IBOutlet weak var unsyncedScansView: UnsyncedScansView!
    @IBOutlet weak var wiFiConnectionView: WiFiConnectionView!
    @IBOutlet weak var syncApiKeyView: SyncApiKeyView!
    
    private let disposeBag = DisposeBag()
    private let deviceStateReporter = DeviceStateReporter.init()
    private let vcFactory = ViewControllerFactory()
    
    private let conferenceState = ConferenceState()
    
    // output
    var roomId: Int! = nil {
        didSet {
            bindInterval()
        }
    }
    
    // INPUTS:
    
    let dateSelected = BehaviorRelay<Date?>.init(value: nil)
    let roomSelected = BehaviorSubject<Room?>.init(value: nil)
    let sessionManuallySelected = BehaviorSubject<Block?>.init(value: nil)
    
    // OUTPUTS:
    
    let sessionSelected = BehaviorSubject<Block?>.init(value: nil)
    
    var selectedInterval = BehaviorRelay<TimeInterval>.init(value: MyTimeInterval.waitToMostRecentSession) // posesava na odg XIB
    
    // input - trebalo je u INIT !!
    var codeScaned = BehaviorSubject<String>.init(value: "")
    private var codeScan: String {
        return try! codeScaned.value()
    }
    
    var sessionId: Int {
        //guard let block = try? sessionManuallySelected.value(),
        guard let block = try? sessionSelected.value(),
            let id = block?.id else {
            return -1 // bez veze je ovo..
        }
        return id
    }
    
    // MARK:- ViewModels
    //fileprivate let roomViewModel = RoomViewModel()

    lazy var settingsViewModel = SettingsViewModel(dataAccess: DataAccess.shared)
    
    lazy fileprivate var autoSelSessionViewModel = AutoSelSessionWithWaitIntervalViewModel.init(roomId: roomId)
    
    lazy fileprivate var unsyncScansViewModel = UnsyncScansViewModel.init(syncScans: unsyncedScansView.syncBtn.rx.tap.asDriver())
    
    override func viewDidLoad() { super.viewDidLoad()
        bindUI()
        bindReachability()
        bindUnsyncedScans()
        bindSyncApiKey()
//        bindState() // ovde je rano za tableView.visibleCells !!
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        bindState()
    }
    
    private func bindUI() { // glue code for selected Room
        
        let interval = Observable.just(MyTimeInterval.waitToMostRecentSession)
                                .asDriver(onErrorJustReturn: MyTimeInterval.waitToMostRecentSession)
        
        let savedAutoSwitchState = DataAccess.shared.userSelection.3
        
        let manuallySelectedSignal = tableView.rx.itemSelected.filter {$0.section == 2 && $0.row == 0} // wtf! pazi magarce !
                                                                .map {_ in return false}
                                                                .asDriver(onErrorJustReturn: false)
                                                                .debug()
        
        let autoSelSessionSwitchSignal = autoSelectSessionsView.controlSwitch.rx.switchActiveSequence
                                                                                .startWith(savedAutoSwitchState)
                                                                                .asDriver(onErrorJustReturn: true)
        
        let input = SettingsViewModel.Input.init(
                        cancelTrigger: cancelSettingsBtn.rx.tap.asDriver(),
                        saveSettingsTrigger: saveSettingsAndExitBtn.rx.tap.asDriver(),
                        dateSelected: dateSelected.asDriver(onErrorJustReturn: nil),
                        roomSelected: roomSelected.asDriver(onErrorJustReturn: nil),
                        sessionSelected: sessionManuallySelected.asDriver(onErrorJustReturn: nil),
                        autoSelSessionSwitch: autoSelSessionSwitchSignal,
                        blockSelectedManually: manuallySelectedSignal,
                        waitInterval:interval
        )
        
        let output = settingsViewModel.transform(input: input)
        
        output.roomTxt
            .drive(roomLbl.rx.text)
            .disposed(by: disposeBag)
        
        output.sessionTxt//.map {$0+$0} test text length
            .drive(sessionLbl.rx.text)
            .disposed(by: disposeBag)

        output.saveSettingsAllowed
            .do(onNext: { allowed in
                self.saveSettingsAndExitBtn.alpha = allowed ? 1 : 0.6
            })
            .drive(saveSettingsAndExitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.selectedBlock // binduj na svoj var koji ce da cita "prethodni vc"
            .do(onNext: { [weak self] _ in
                guard let sSelf = self else {return}
                sSelf.dismiss(animated: true, completion: nil) // ako radis behavior umesto bind na UI, koristi Subsc
            })
            .drive(self.sessionSelected)
            .disposed(by: disposeBag)
        
        output.sessionInfo.asObservable()
            .subscribe(onNext: { [weak self] (info) in
                guard let sSelf = self else {return}
                guard let info = info else { // ako nemas info, tapnuo je cancel na BlocksVC
                    return
                }
                
                let batStateManager = BatteryManager.init()
                
                sSelf.deviceStateReporter.sessionIsSet(info: info,
                                                       battery_info: batStateManager.info,
                                                       app_active: true) // moras biti true ako je izabrao session
            })
            .disposed(by: disposeBag)
        
        output.dateTxt
            .skip(1)
            .drive(dateLbl.rx.text)
            .disposed(by: disposeBag)
        
        DataAccess.shared.output.map {$0.3}
            .take(1)
            .asDriver(onErrorJustReturn: true)
            .drive(autoSelectSessionsView.controlSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
    }

    private func bindReachability() {
        
        connectedToInternet()
            .debug()
            .asDriver(onErrorJustReturn: false)
            .drive(wiFiConnectionView.rx.connected) // ovo je var tipa binder na xib-u
            .disposed(by: disposeBag)
        
    }
    
    private func bindUnsyncedScans() {
        
        unsyncScansViewModel.syncScansCount
            .map {"\($0)"}
            .bind(to: unsyncedScansView.countLbl.rx.text)
            .disposed(by: disposeBag)
        
        unsyncScansViewModel.syncControlAvailable
            .map(!)
            .bind(to: unsyncedScansView.syncBtn.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSyncApiKey() {
        
        syncApiKeyView.oSyncBtnTap
            .subscribe(onNext: { [weak self] _ in
                
                self?.conferenceState.syncApiKeyIsNeeded()
                
            }).disposed(by: disposeBag)
    }
    
    private func bindInterval() {
        
        selectedInterval // ovo je bilo ok dok nisam ubacio picker kontrolu
            .asObservable()
            .bind(to: autoSelSessionViewModel.inSelTimeInterval)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState() {
        
        roomSelected
            .asDriver(onErrorJustReturn: nil) // ovu liniju napisi u modelu...
            .drive(tableView.rx.roomValidationSideEffects) // ovo je rx world, npr Binder na extension Reactive where Base: TableView
            .disposed(by: disposeBag)
    }
    
    private func getActualCodeReport() -> CodeReport { // refactor - delete
        print("KONACNO IMAM DA JE codeScan = \(codeScan)")
        return CodeReport.init(code: codeScan,
                               sessionId: sessionId,
                               date: Date.now)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let name = segue.identifier, name == "segueShowRooms",
            let roomsVC = segue.destination as? RoomsVC else { return }
        
        roomsVC.selRoomDriver
            .do(onNext: { room in // side-effect
                self.roomId = room?.id
            })
            .drive(roomSelected)
            .disposed(by: disposeBag)
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.item) {
        
        case (0,0):
            
            let datesVC = vcFactory.makeDatesVC()
            self.navigationController?.pushViewController(datesVC, animated: true)
            
            datesVC.datesViewmodel.selectedDate
                .skip(1) // jer je iniated sa NIL ...
                .subscribe(onNext: { [weak self] date in
                    self?.dateSelected.accept(date)
                    self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
            
        //case (1, 0): print("auto segue ka rooms...")
            
        case (2, 0):
            
            guard let roomId = roomId,
//                !autoSelectSessionsView.controlSwitch.isOn,
                let blocksVC = storyboard?.instantiateViewController(withIdentifier: "BlocksVC") as? BlocksVC else {
                    return
            }
            
            blocksVC.selectedRoomId = roomId
            blocksVC.selectedDate = dateSelected.value
            
            self.autoSelectSessionsView.controlSwitch.isOn = false
            
            navigationController?.pushViewController(blocksVC, animated: true)
            
            blocksVC.selectedBlock
                .subscribe(onNext: { [weak self] block in
                    guard let sSelf = self else {return}
                    sSelf.sessionManuallySelected.onNext(block)
                    sSelf.sessionSelected.onNext(block) // moze li ovo bolje....
                })
                .disposed(by: disposeBag)
            
        default: break
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    deinit { print("deinit.setingsVC") }
    
}
