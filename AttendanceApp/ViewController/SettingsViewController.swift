//
//  SettingsViewController.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UITableViewController, Storyboarded {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var roomLbl: UILabel!
    @IBOutlet weak var sessionLbl: UILabel!
    
    @IBOutlet weak var saveSettingsAndExitBtn: UIButton!
    @IBOutlet weak var cancelSettingsBtn: UIBarButtonItem!
    
    @IBOutlet weak var autoSelectSessionsView: AutoSelectSessionsView!
    
    @IBOutlet weak var refreshResourcesBtn: ActionUIButton!
    @IBOutlet weak var unsyncedScansView: UnsyncedScansView!
    @IBOutlet weak var wiFiConnectionView: WiFiConnectionView!
    
    var settingsViewModel: SettingsViewModel!
    var scanSettingsRepo: IScanSettingsRepository!
    private let disposeBag = DisposeBag()
    
    // INPUTS: property injection
    var dateSelected: BehaviorRelay<Date?>!
    var roomSelected: BehaviorSubject<Int?>!
    var blockManuallySelected: BehaviorSubject<Int?>!
    
    // OUTPUTS:
    var blockSelected: BehaviorSubject<Int?>!
    
    lazy fileprivate var unsyncScansViewModel = UnsyncScansViewModelFactory.make(syncScansTap: unsyncedScansView.syncBtn.rx.tap.asDriver())
    var refreshResourcesViewModelFactory: RefreshResourcesViewModelFactory!
    private var refreshResourcesVM: RefreshResourcesViewModel {
        return refreshResourcesViewModelFactory.make()
    }
    
    override func viewDidLoad() { super.viewDidLoad()

        bindUI()
        bindRefreshResources()
        bindReachability()
        bindUnsyncedScans()
//        bindState() // ovde je rano za tableView.visibleCells !!
    }
    
    override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated)
        enableOrDisableBlockAreaUponRoomSelected()
    }
    
    private func bindUI() { // glue code for selected Room
        
        let manuallySelectedSignal = tableView.rx.itemSelected.filter
            {$0.section == 2 && $0.row == 0} // jako slabo...
            .map {_ in return false}
            .asDriver(onErrorJustReturn: false)//.debug()
        
        let settings = scanSettingsRepo.getScanSettings()
        let savedAutoSwitchState = (settings.blockId != nil) ? settings.autoSwitch : true
        let blockSwitchSignal = autoSelectSessionsView.controlSwitch
                                            .rx.switchActiveSequence
                                            .startWith(savedAutoSwitchState)
                                            .asDriver(onErrorJustReturn: true)
        
        let blockManuallyDriver = blockManuallySelected.share(replay:1)
            .asDriver(onErrorJustReturn: nil)
        
        let input = SettingsViewModel.Input.init(
                        cancelTrigger: cancelSettingsBtn.rx.tap.asDriver(),
                        saveSettingsTrigger: saveSettingsAndExitBtn.rx.tap.asDriver(),
                        dateSelected: dateSelected.asDriver(onErrorJustReturn: nil),
                        roomSelected: roomSelected.asDriver(onErrorJustReturn: nil),
                        sessionSelected: blockManuallyDriver,
                        sessionSwitch: blockSwitchSignal,
                        blockSelectedManually: manuallySelectedSignal)
        
        let output = settingsViewModel.transform(input: input)
        
        output.dateTxt.drive(dateLbl.rx.text).disposed(by: disposeBag)
        output.sessionTxt.drive(sessionLbl.rx.text).disposed(by: disposeBag)
        output.roomTxt.drive(roomLbl.rx.text).disposed(by: disposeBag)
        output.dateTxtColor.drive(dateLbl.rx.textColor).disposed(by: disposeBag)
        
        output.saveSettingsAllowed
            .do(onNext: { allowed in
                self.saveSettingsAndExitBtn.alpha = allowed ? 1 : 0.6
            })
            .drive(saveSettingsAndExitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.finishTrigger.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let sSelf = self else {return}
                sSelf.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        scanSettingsRepo.getObsScanSettings().map {$0.autoSwitch}
            .take(1)
            .asDriver(onErrorJustReturn: true)
            .drive(autoSelectSessionsView.controlSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshResources() {
        
        let refreshResourcesInput = RefreshResourcesViewModel.Input.init(tap: refreshResourcesBtn.rx.tap.asObservable())
        
        let refreshResourcesOutput = refreshResourcesVM.transform(input: refreshResourcesInput)
        
        refreshResourcesOutput.resourcesDownloaded
            .subscribe(onNext: { [weak self] (_) in// print("refreshRes: set loading")
                self?.refreshResourcesBtn.setLoading(true)
            }, onError: { [weak self] (err) in//print("refreshRes: err catched, display err")
                self?.refreshResourcesFinished()
            }, onCompleted: { [weak self] in//print("refreshRes: finished catched")
                self?.refreshResourcesFinished()
            }).disposed(by: disposeBag)
    }
    
    private func refreshResourcesFinished() {
        self.refreshResourcesBtn.setLoading(false)
        self.bindRefreshResources()
    }
    
    private func bindReachability() {
        
        connectedToInternet()//.debug()
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
    
    private func enableOrDisableBlockAreaUponRoomSelected() {
        
        roomSelected
            .asDriver(onErrorJustReturn: nil) // ovu liniju napisi u modelu...
            .drive(tableView.rx.roomValidationSideEffects)
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.item) {
        
        case (0,0):
            
            let datesVC = DatesViewControllerFactory.make()
            self.navigationController?.pushViewController(datesVC, animated: true)

            datesVC.datesViewmodel.selectedDate
            .debug()
                .asDriver(onErrorJustReturn: nil)
                .do(onNext: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                .drive(self.dateSelected)
                .disposed(by: disposeBag)
            
        case (1, 0):
            
            let roomsVC = RoomsViewControllerFactory.make()
            roomsVC.selRoomDriver
                .do(onNext: { _ in // side-effect
                    self.navigationController?.popViewController(animated: true)
                })
                .drive(self.roomSelected)
                .disposed(by: disposeBag)
            
            self.navigationController?.pushViewController(roomsVC, animated: true)
            
        case (2, 0):
            guard let roomId = try! roomSelected.value() else {
                return // should be fatal
            }
            
            let blocksVC = BlocksViewControllerFactory.make(roomId: roomId,
                                                            selDate: self.dateSelected.value)
            
            self.autoSelectSessionsView.controlSwitch.isOn = false
            
            navigationController?.pushViewController(blocksVC, animated: true)
            
            blocksVC.selectedBlock
                .subscribe(onNext: { [weak self] blockId in
                    guard let sSelf = self else {return}
                    sSelf.blockManuallySelected.onNext(blockId)
                    sSelf.blockSelected.onNext(blockId) // moze li ovo bolje....
                })
                .disposed(by: disposeBag)
            
        default: break
        }
    }
    
    override var shouldAutorotate: Bool { return false }
    
}

extension RefreshResourcesViewModel: ViewModelType {
    struct Input {
        var tap: Observable<Void>
    }
    struct Output {
        var resourcesDownloaded: Observable<Void>
    }
//    func transform(input: Input) -> Output {
//        let errorSignal: Observable<Void> =
//            input.tap.delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
//            .map { (_) in
//                throw LoginError.badParsing
//            }
//        let signal = Observable.merge([input.tap, errorSignal])
//        return Output(resourcesDownloaded: signal)
//    }
    func transform(input: Input) -> Output {
        let completeSignal: Observable<Void> =
            input.tap
                .delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        
        let composite = input.tap.takeUntil(completeSignal)
        return Output(resourcesDownloaded: composite)
    }
}

class RefreshResourcesViewModel {
    private var resourcesWorker: ICampaignResourcesWorker
    init(resourcesWorker: ICampaignResourcesWorker) {
        self.resourcesWorker = resourcesWorker
    }
    
}

class RefreshResourcesViewModelFactory {
    func make() -> RefreshResourcesViewModel {
        RefreshResourcesViewModel(resourcesWorker: CampaignResourcesWorkerFactory.make())
    }
}
