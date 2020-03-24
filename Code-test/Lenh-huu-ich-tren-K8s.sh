# Lấy hông tin các Node nhiều hơn
kubectl get node -o wide

# Liệt kê Tài nguyên / tên viết tắt
kubectl api-resources

# Gen dashboard token
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

# Get cluster API 
kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}' 

# Lấy thông tin Node/Pod....
kubectl get no TEN-Node
kubectl get po TEN-Pod
...

# Lấy thông tin Manifest của Pod nào đó
kubectl get po/TEN-Pod -o yaml
kubectl get po/TEN-Pod -o yaml > xxx.yaml # lưu ra file

# Edit Manifest của Pod
kubectl edit po/TEN-Pod

# Xem logs của Pod
kubectl logs po/TEN-Pod

# Chạy cmd (exec) trong Pod
kubectl exec -it TEN-Pod -c TEN-Container Lệnh
kubectl exec -it TEN-Pod -c TEN-Container bash

# Event trên cluster
kubectl get ev

# Lấy thông tin chi tiết Node
kubectl describe node TEN-Node

# Gán Lable (Nhãn) cho các đối tượng
kubectl lable node TEN-DoiTuong TEN-Nhan=Gia-Tri-Nhan
VD: kubectl lable node Kworker1 KworkerAPI=DechayAPI

# Lấy đối tượng có chung Lable
kubectl get node -l "TEN-Nhan"

# Xóa lable
kubectl lable node TEN-DoiTuong TEN-Nhan=Gia-Tri-Nhan- #Thêm dấu - ở cuối

# Cấu trúc và khai báo Pod 
kubectl explain pod --recursive=true

# Cài đặt các file Manifest
kubectl apply -f XXX-XXX.yaml

# Xóa cách cài đặt đã dùng Manifest
kubectl delete -f XXX-XXX.yaml

################# Deployment #########################
# Xem thông tin Deployment
kubectl describe deploy/TEN-deploy

# Xem số lần cập nhật deploy
kubectl rollout history deploy/TEN-deploy

# Xem nội dung chi tiết của từng lần
kubectl rollout history deploy/TEN-deploy --revision=2 # xem lần cập nhật thứ 2

# Quay lại 1 bản cập nhật nào đó
kubectl rollout undo deploy/TEN-deploy --to-revision=2 # quay về bản 2

# Thay đổi số lượng Replica bằng tay (manual-Scale)
kubectl scale deploy/TEN-deploy --replicas=10 # 10 là số lượng

# Thay đổi số lượng Replica tự động (auto-Scale)
kubectl autoscale deploy/TEN-deploy --min=3 --max=8


