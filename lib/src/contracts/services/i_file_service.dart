abstract interface class IFileService {
    read(String folderPath, String fileName);

    void save(String folderPath, String fileName, content);

    void delete(String folderPath, String fileName);
}