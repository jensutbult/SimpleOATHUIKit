import UIKit

class CredentialTable: UITableViewController {
    
    struct Credential {
        let issuer: String?
        let account: String
    }
    
    var credentials = [Credential]()
    var nfcSessionObserver: NSKeyValueObservation? = nil
    
    @IBAction func startNFCSession(_ sender: Any) {
        YubiKitManager.shared.nfcSession.startIso7816Session()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Can't do key value observation on the protocol so we have to cast it to its concrete implementation
        guard let nfcSession = YubiKitManager.shared.nfcSession as? YKFNFCSession else { return }
        
        // Observe changes to the nfc session
        nfcSessionObserver = nfcSession.observe(\.iso7816SessionState, changeHandler: { [weak self] session, change in
            // If session state is open unwrap the YKFKeyOATHServiceProtocol
            if session.iso7816SessionState == .open, let service = session.oathService {
                let request = YKFKeyOATHCalculateAllRequest(timestamp: Date().addingTimeInterval(10))
                service.execute(request!) { [weak self] (response, error) in
                    // Unwrap response and safely cast the credentials of [Any] to [YKFOATHCredentialCalculateResult]
                    guard let credentials = response?.credentials as? [YKFOATHCredentialCalculateResult] else { return }
                    // Stop the nfc session
                    YubiKitManager.shared.nfcSession.stopIso7816Session()
                    // Map the YKFOATHCredentialCalculateResult to Credentials
                    self?.credentials = credentials.map {
                        Credential(issuer: $0.issuer, account: $0.account)
                    }
                    // Reload table data on the main thread
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credentials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        let account = credentials[indexPath.row]
        cell.textLabel?.text = account.account
        cell.detailTextLabel?.text = account.issuer
        return cell
    }
}
